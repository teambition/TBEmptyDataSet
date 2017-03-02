//
//  TBEmptyDataSet.swift
//  TBEmptyDataSet
//
//  Created by Xin Hong on 15/11/19.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

extension UIScrollView {
    // MARK: - Properties
    public var emptyDataSetDataSource: TBEmptyDataSetDataSource? {
        get {
            let container = objc_getAssociatedObject(self, &AssociatedKeys.emptyDataSetDataSource) as? WeakObjectContainer
            return container?.object as? TBEmptyDataSetDataSource
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.emptyDataSetDataSource, WeakObjectContainer(object: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

                switch self {
                case is UITableView:
                    UITableView.tb_swizzleTableViewReloadData
                    UITableView.tb_swizzleTableViewEndUpdates
                case is UICollectionView:
                    UICollectionView.tb_swizzleCollectionViewReloadData
                    UICollectionView.tb_swizzleCollectionViewPerformBatchUpdates
                default:
                    break
                }
            } else {
                handlingInvalidEmptyDataSet()
            }
        }
    }

    public var emptyDataSetDelegate: TBEmptyDataSetDelegate? {
        get {
            let container = objc_getAssociatedObject(self, &AssociatedKeys.emptyDataSetDelegate) as? WeakObjectContainer
            return container?.object as? TBEmptyDataSetDelegate
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.emptyDataSetDelegate, WeakObjectContainer(object: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                handlingInvalidEmptyDataSet()
            }
        }
    }

    internal var emptyDataView: EmptyDataView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.emptyDataView) as? EmptyDataView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.emptyDataView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // MARK: - Public
    public var emptyDataViewVisible: Bool {
        if let emptyDataView = emptyDataView {
            return !emptyDataView.isHidden
        }
        return false
    }

    public func updateEmptyDataSetIfNeeded() {
        reloadEmptyDataSet()
    }

    // MARK: - Data source and delegate getters
    fileprivate func emptyDataSetImage() -> UIImage? {
        return emptyDataSetDataSource?.imageForEmptyDataSet(in: self)
    }

    fileprivate func emptyDataSetTitle() -> NSAttributedString? {
        return emptyDataSetDataSource?.titleForEmptyDataSet(in: self)
    }

    fileprivate func emptyDataSetDescription() -> NSAttributedString? {
        return emptyDataSetDataSource?.descriptionForEmptyDataSet(in: self)
    }

    fileprivate func emptyDataSetImageTintColor() -> UIColor? {
        return emptyDataSetDataSource?.imageTintColorForEmptyDataSet(in: self)
    }

    fileprivate func emptyDataSetBackgroundColor() -> UIColor? {
        return emptyDataSetDataSource?.backgroundColorForEmptyDataSet(in: self)
    }

    fileprivate func emptyDataSetVerticalOffset() -> CGFloat {
        return emptyDataSetDataSource?.verticalOffsetForEmptyDataSet(in: self) ?? DefaultValues.verticalOffset
    }

    fileprivate func emptyDataSetVerticalSpaces() -> [CGFloat] {
        return emptyDataSetDataSource?.verticalSpacesForEmptyDataSet(in: self) ?? DefaultValues.verticalSpaces
    }

    fileprivate func emptyDataSetCustomView() -> UIView? {
        return emptyDataSetDataSource?.customViewForEmptyDataSet(in: self)
    }

    fileprivate func emptyDataSetShouldDisplay() -> Bool {
        return emptyDataSetDelegate?.emptyDataSetShouldDisplay(in: self) ?? true
    }

    fileprivate func emptyDataSetTapEnabled() -> Bool {
        return emptyDataSetDelegate?.emptyDataSetTapEnabled(in: self) ?? true
    }

    fileprivate func emptyDataSetScrollEnabled() -> Bool {
        return emptyDataSetDelegate?.emptyDataSetScrollEnabled(in: self) ?? false
    }

    // MARK: - Helper
    func didTapEmptyDataView(_ sender: Any) {
        emptyDataSetDelegate?.emptyDataSetDidTapEmptyView(in: self)
    }

    fileprivate func makeEmptyDataView() -> EmptyDataView {
        let emptyDataView = EmptyDataView(frame: frame)
        emptyDataView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        emptyDataView.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapEmptyDataView(_:)))
        emptyDataView.addGestureRecognizer(tapGesture)
        emptyDataView.tapGesture = tapGesture
        return emptyDataView
    }

    fileprivate func emptyDataSetAvailable() -> Bool {
        if let _ = emptyDataSetDataSource {
            return (self is UITableView) || (self is UICollectionView)
        }
        return false
    }

    fileprivate func cellsCount() -> Int {
        var count = 0
        if let tableView = self as? UITableView {
            if let dataSource = tableView.dataSource {
                if dataSource.responds(to: TableViewSelectors.numberOfSections) {
                    let sections = dataSource.numberOfSections?(in: tableView) ?? 0
                    for section in 0..<sections {
                        count += dataSource.tableView(tableView, numberOfRowsInSection: section)
                    }
                }
            }
        } else if let collectionView = self as? UICollectionView {
            if let dataSource = collectionView.dataSource {
                if dataSource.responds(to: CollectionViewSelectors.numberOfSections) {
                    let sections = dataSource.numberOfSections?(in: collectionView) ?? 0
                    for section in 0..<sections {
                        count += dataSource.collectionView(collectionView, numberOfItemsInSection: section)
                    }
                }
            }
        }

        return count
    }

    fileprivate func handlingInvalidEmptyDataSet() {
        emptyDataSetDelegate?.emptyDataSetWillDisappear(in: self)

        emptyDataView?.reset()
        emptyDataView?.removeFromSuperview()
        emptyDataView = nil
        isScrollEnabled = true

        emptyDataSetDelegate?.emptyDataSetDidDisappear(in: self)
    }

    // MARK: - Display
    // swiftlint:disable function_body_length
    fileprivate func reloadEmptyDataSet() {
        guard emptyDataSetAvailable() else {
            return
        }

        guard emptyDataSetShouldDisplay() && cellsCount() == 0 else {
            if emptyDataViewVisible {
                handlingInvalidEmptyDataSet()
            }
            return
        }

        let emptyDataView: EmptyDataView = {
            if let emptyDataView = self.emptyDataView {
                return emptyDataView
            } else {
                let emptyDataView = makeEmptyDataView()
                self.emptyDataView = emptyDataView
                return emptyDataView
            }
        }()
        emptyDataSetDelegate?.emptyDataSetWillAppear(in: self)

        if emptyDataView.superview == nil {
            if (self is UITableView || self is UICollectionView) && subviews.count > 1 {
                insertSubview(emptyDataView, at: 0)
            } else {
                addSubview(emptyDataView)
            }
        }

        emptyDataView.prepareForDisplay()

        emptyDataView.verticalOffset = emptyDataSetVerticalOffset()
        emptyDataView.verticalSpaces = emptyDataSetVerticalSpaces()

        if let customView = emptyDataSetCustomView() {
            emptyDataView.customView = customView
        } else {
            if let imageTintColor = emptyDataSetImageTintColor() {
                emptyDataView.imageView.image = emptyDataSetImage()?.withRenderingMode(.alwaysTemplate)
                emptyDataView.imageView.tintColor = imageTintColor
            } else {
                emptyDataView.imageView.image = emptyDataSetImage()?.withRenderingMode(.alwaysOriginal)
            }

            emptyDataView.titleLabel.attributedText = emptyDataSetTitle()
            emptyDataView.descriptionLabel.attributedText = emptyDataSetDescription()
        }

        emptyDataView.backgroundColor = emptyDataSetBackgroundColor()
        emptyDataView.isHidden = false
        emptyDataView.clipsToBounds = true
        emptyDataView.tapGesture?.isEnabled = emptyDataSetTapEnabled()
        isScrollEnabled = emptyDataSetScrollEnabled()

        emptyDataView.setConstraints()
        emptyDataView.layoutIfNeeded()

        emptyDataSetDelegate?.emptyDataSetDidAppear(in: self)
    }

    // MARK: - Method swizzling
    fileprivate class func tb_swizzleMethod(for aClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(aClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector)

        let didAddMethod = class_addMethod(aClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))

        if didAddMethod {
            class_replaceMethod(aClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }

    // swiftlint:disable variable_name
    fileprivate static let tb_swizzleTableViewReloadData: () = {
        let originalSelector = TableViewSelectors.reloadData
        let swizzledSelector = Selectors.tableViewSwizzledReloadData

        tb_swizzleMethod(for: UITableView.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()

    // swiftlint:disable variable_name
    fileprivate static let tb_swizzleTableViewEndUpdates: () = {
        let originalSelector = TableViewSelectors.endUpdates
        let swizzledSelector = Selectors.tableViewSwizzledEndUpdates

        tb_swizzleMethod(for: UITableView.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()

    // swiftlint:disable variable_name
    fileprivate static let tb_swizzleCollectionViewReloadData: () = {
        let originalSelector = CollectionViewSelectors.reloadData
        let swizzledSelector = Selectors.collectionViewSwizzledReloadData

        tb_swizzleMethod(for: UICollectionView.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()

    // swiftlint:disable variable_name
    fileprivate static let tb_swizzleCollectionViewPerformBatchUpdates: () = {
        let originalSelector = CollectionViewSelectors.performBatchUpdates
        let swizzledSelector = Selectors.collectionViewSwizzledPerformBatchUpdates

        tb_swizzleMethod(for: UICollectionView.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()

    func tb_tableViewSwizzledReloadData() {
        tb_tableViewSwizzledReloadData()
        reloadEmptyDataSet()
    }

    func tb_tableViewSwizzledEndUpdates() {
        tb_tableViewSwizzledEndUpdates()
        reloadEmptyDataSet()
    }

    func tb_collectionViewSwizzledReloadData() {
        tb_collectionViewSwizzledReloadData()
        reloadEmptyDataSet()
    }

    func tb_collectionViewSwizzledPerformBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
        tb_collectionViewSwizzledPerformBatchUpdates(updates) { [weak self](completed) in
            completion?(completed)
            self?.reloadEmptyDataSet()
        }
    }
}
