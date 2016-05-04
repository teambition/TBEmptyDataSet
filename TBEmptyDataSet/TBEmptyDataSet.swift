//
//  TBEmptyDataSet.swift
//  TBEmptyDataSet
//
//  Created by Xin Hong on 15/11/19.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

public protocol TBEmptyDataSetDataSource: NSObjectProtocol {
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage?
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString?
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString?

    func imageTintColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor?
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor?

    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat
    func verticalSpacesForEmptyDataSet(scrollView: UIScrollView!) -> [CGFloat]

    func customViewForEmptyDataSet(scrollView: UIScrollView!) -> UIView?
}

public protocol TBEmptyDataSetDelegate: NSObjectProtocol {
    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool
    func emptyDataSetTapEnabled(scrollView: UIScrollView!) -> Bool
    func emptyDataSetScrollEnabled(scrollView: UIScrollView!) -> Bool

    func emptyDataSetDidTapView(scrollView: UIScrollView!)

    func emptyDataSetWillAppear(scrollView: UIScrollView!)
    func emptyDataSetDidAppear(scrollView: UIScrollView!)
    func emptyDataSetWillDisappear(scrollView: UIScrollView!)
    func emptyDataSetDidDisappear(scrollView: UIScrollView!)
}

// MARK: - UIScrollView Extension
extension UIScrollView: UIGestureRecognizerDelegate {
    // MARK: - Properties
    public var emptyDataSetDataSource: TBEmptyDataSetDataSource? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.emptyDataSetDataSource) as? TBEmptyDataSetDataSource
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.emptyDataSetDataSource, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

                if self is UITableView {
                    UITableView.tb_swizzleTableViewReloadData()
                    UITableView.tb_swizzleTableViewEndUpdates()
                }
                if self is UICollectionView {
                    UICollectionView.tb_swizzleCollectionViewReloadData()
                }
            } else {
                handlingInvalidEmptyDataSet()
            }
        }
    }

    public var emptyDataSetDelegate: TBEmptyDataSetDelegate? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.emptyDataSetDelegate) as? TBEmptyDataSetDelegate
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.emptyDataSetDelegate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                handlingInvalidEmptyDataSet()
            }
        }
    }

    public var emptyDataViewVisible: Bool {
        if let emptyDataView = objc_getAssociatedObject(self, &AssociatedKeys.emptyDataView) as? EmptyDataView {
            return !emptyDataView.hidden
        }
        return false
    }

    private var emptyDataView: EmptyDataView! {
        var emptyDataView = objc_getAssociatedObject(self, &AssociatedKeys.emptyDataView) as? EmptyDataView
        if emptyDataView == nil {
            emptyDataView = EmptyDataView(frame: frame)
            emptyDataView!.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            emptyDataView!.hidden = true

            emptyDataView!.tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIScrollView.didTapEmptyDataView(_:)))
            emptyDataView!.tapGesture.delegate = self
            emptyDataView!.addGestureRecognizer(emptyDataView!.tapGesture)
            setEmptyDataView(emptyDataView!)
        }
        return emptyDataView!
    }

    // MARK: - Setters
    private func setEmptyDataView(emptyDataView: EmptyDataView?) {
        objc_setAssociatedObject(self, &AssociatedKeys.emptyDataView, emptyDataView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    // MARK: - DataSource getters
    private func emptyDataSetImage() -> UIImage? {
        return emptyDataSetDataSource?.imageForEmptyDataSet(self)
    }

    private func emptyDataSetTitle() -> NSAttributedString? {
        return emptyDataSetDataSource?.titleForEmptyDataSet(self)
    }

    private func emptyDataSetDescription() -> NSAttributedString? {
        return emptyDataSetDataSource?.descriptionForEmptyDataSet(self)
    }

    private func emptyDataSetImageTintColor() -> UIColor? {
        return emptyDataSetDataSource?.imageTintColorForEmptyDataSet(self)
    }

    private func emptyDataSetBackgroundColor() -> UIColor? {
        return emptyDataSetDataSource?.backgroundColorForEmptyDataSet(self)
    }

    private func emptyDataSetVerticalOffset() -> CGFloat {
        return emptyDataSetDataSource?.verticalOffsetForEmptyDataSet(self) ?? DefaultValues.verticalOffset
    }

    private func emptyDataSetVerticalSpaces() -> [CGFloat] {
        return emptyDataSetDataSource?.verticalSpacesForEmptyDataSet(self) ?? [DefaultValues.verticalSpace, DefaultValues.verticalSpace]
    }

    private func emptyDataSetCustomView() -> UIView? {
        return emptyDataSetDataSource?.customViewForEmptyDataSet(self)
    }

    // MARK: - Delegate getters
    private func emptyDataSetShouldDisplay() -> Bool {
        return emptyDataSetDelegate?.emptyDataSetShouldDisplay(self) ?? true
    }

    private func emptyDataSetTapEnabled() -> Bool {
        return emptyDataSetDelegate?.emptyDataSetTapEnabled(self) ?? true
    }

    private func emptyDataSetScrollEnabled() -> Bool {
        return emptyDataSetDelegate?.emptyDataSetScrollEnabled(self) ?? false
    }

    // MARK: - Public
    public func updateEmptyDataSetIfNeeded() {
        reloadEmptyDataSet()
    }

    // MARK: - View events
    func didTapEmptyDataView(sender: AnyObject) {
        emptyDataSetDelegate?.emptyDataSetDidTapView(self)
    }

    private func emptyDataSetWillAppear() {
        emptyDataSetDelegate?.emptyDataSetWillAppear(self)
    }

    private func emptyDataSetDidAppear() {
        emptyDataSetDelegate?.emptyDataSetDidAppear(self)
    }

    private func emptyDataSetWillDisappear() {
        emptyDataSetDelegate?.emptyDataSetWillDisappear(self)
    }

    private func emptyDataSetDidDisappear() {
        emptyDataSetDelegate?.emptyDataSetDidDisappear(self)
    }

    // MARK: - Helper
    private func emptyDataSetAvailable() -> Bool {
        if let _ = emptyDataSetDataSource {
            return isKindOfClass(UITableView.self) || isKindOfClass(UICollectionView.self) || isKindOfClass(UIScrollView.self)
        }
        return false
    }

    private func cellsCount() -> Int {
        var count = 0
        if let tableView = self as? UITableView {
            if let dataSource = tableView.dataSource {
                if dataSource.respondsToSelector(TableViewSelectors.numberOfSections) {
                    let sections = dataSource.numberOfSectionsInTableView!(tableView)
                    for section in 0..<sections {
                        count += dataSource.tableView(tableView, numberOfRowsInSection: section)
                    }
                }
            }
        } else if let collectionView = self as? UICollectionView {
            if let dataSource = collectionView.dataSource {
                if dataSource.respondsToSelector(CollectionViewSelectors.numberOfSections) {
                    let sections = dataSource.numberOfSectionsInCollectionView!(collectionView)
                    for section in 0..<sections {
                        count += dataSource.collectionView(collectionView, numberOfItemsInSection: section)
                    }
                }
            }
        }

        return count
    }

    private func handlingInvalidEmptyDataSet() {
        emptyDataSetWillDisappear()

        emptyDataView.resetEmptyDataView()
        emptyDataView.removeFromSuperview()
        setEmptyDataView(nil)
        scrollEnabled = true

        emptyDataSetDidDisappear()
    }

    // MARK: - UIGestureRecognizer delegate
    override public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view?.isEqual(EmptyDataView) == true {
            return emptyDataSetTapEnabled()
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }

    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isEqual(emptyDataView.tapGesture) || otherGestureRecognizer.isEqual(emptyDataView.tapGesture) {
            return true
        }

        return false
    }

    // MARK: - Reload
    // swiftlint:disable function_body_length
    private func reloadEmptyDataSet() {
        if !emptyDataSetAvailable() {
            return
        }

        if !emptyDataSetShouldDisplay() || cellsCount() > 0 {
            if emptyDataViewVisible {
                handlingInvalidEmptyDataSet()
            }
            return
        }

        emptyDataSetWillAppear()

        if emptyDataView.superview == nil {
            if (self is UITableView || self is UICollectionView) && subviews.count > 1 {
                insertSubview(emptyDataView, atIndex: 0)
            } else {
                addSubview(emptyDataView)
            }
        }
        emptyDataView.resetEmptyDataView()

        emptyDataView!.verticalOffset = emptyDataSetVerticalOffset()
        emptyDataView!.verticalSpaces = emptyDataSetVerticalSpaces()

        if let customView = emptyDataSetCustomView() {
            emptyDataView.customView = customView
        } else {
            if let image = emptyDataSetImage() {
                if let imageTintColor = emptyDataSetImageTintColor() {
                    emptyDataView!.imageView.image = image.imageWithRenderingMode(.AlwaysTemplate)
                    emptyDataView!.imageView.tintColor = imageTintColor
                } else {
                    emptyDataView!.imageView.image = image.imageWithRenderingMode(.AlwaysOriginal)
                }
            }

            if let title = emptyDataSetTitle() {
                emptyDataView.titleLabel.attributedText = title
            }

            if let description = emptyDataSetDescription() {
                emptyDataView.descriptionLabel.attributedText = description
            }
        }

        emptyDataView.backgroundColor = emptyDataSetBackgroundColor()
        emptyDataView.hidden = false
        emptyDataView.clipsToBounds = true
        emptyDataView.tapGesture.enabled = emptyDataSetTapEnabled()
        scrollEnabled = emptyDataSetScrollEnabled()

        emptyDataView.setConstraints()
        emptyDataView.layoutIfNeeded()

        emptyDataSetDidAppear()
    }

    // MARK: - Method swizzling
    private class func tb_swizzleMethod(originalSelector: Selector, swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)

        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))

        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }

    private class func tb_swizzleTableViewReloadData() {
        struct EmptyDataSetSwizzleToken {
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&EmptyDataSetSwizzleToken.onceToken) {
            let originalSelector = TableViewSelectors.reloadData
            let swizzledSelector = Selectors.tableViewSwizzledReloadData

            tb_swizzleMethod(originalSelector, swizzledSelector: swizzledSelector)
            print(#function)
        }
    }

    private class func tb_swizzleTableViewEndUpdates() {
        struct EmptyDataSetSwizzleToken {
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&EmptyDataSetSwizzleToken.onceToken) {
            let originalSelector = TableViewSelectors.endUpdates
            let swizzledSelector = Selectors.tableViewSwizzledEndUpdates

            tb_swizzleMethod(originalSelector, swizzledSelector: swizzledSelector)
            print(#function)
        }
    }

    private class func tb_swizzleCollectionViewReloadData() {
        struct EmptyDataSetSwizzleToken {
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&EmptyDataSetSwizzleToken.onceToken) {
            let originalSelector = CollectionViewSelectors.reloadData
            let swizzledSelector = Selectors.collectionViewSwizzledReloadData

            tb_swizzleMethod(originalSelector, swizzledSelector: swizzledSelector)
            print(#function)
        }
    }

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
}
