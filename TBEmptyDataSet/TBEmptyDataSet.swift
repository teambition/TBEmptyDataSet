//
//  TBEmptyDataSet.swift
//  TBEmptyDataSet
//
//  Created by Xin Hong on 15/11/19.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

// MARK: - EmptyDataView
private class EmptyDataView: UIView {
    private struct Screen {
        static let width = UIScreen.mainScreen().bounds.width
        static let height = UIScreen.mainScreen().bounds.height
    }
    
    private struct ViewStrings {
        static let contentView = "contentView"
        static let imageView = "imageView"
        static let titleLabel = "titleLabel"
        static let descriptionLabel = "descriptionLabel"
        static let customView = "customView"
    }
    
    // MARK: - Properties
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor.clearColor()
        contentView.userInteractionEnabled = true
        contentView.alpha = 0
        return contentView
    }()
    
    lazy var imageView: UIImageView = { [unowned self] in
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clearColor()
        imageView.contentMode = .ScaleAspectFill
        imageView.userInteractionEnabled = false
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
    lazy var titleLabel: UILabel = { [unowned self] in
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont.systemFontOfSize(27)
        titleLabel.textColor = UIColor(white: 0.6, alpha: 1)
        titleLabel.textAlignment = .Center
        titleLabel.lineBreakMode = .ByWordWrapping
        titleLabel.numberOfLines = 0
        self.contentView.addSubview(titleLabel)
        return titleLabel
    }()
    
    lazy var descriptionLabel: UILabel = { [unowned self] in
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.backgroundColor = UIColor.clearColor()
        descriptionLabel.font = UIFont.systemFontOfSize(17)
        descriptionLabel.textColor = UIColor(white: 0.6, alpha: 1)
        descriptionLabel.textAlignment = .Center
        descriptionLabel.lineBreakMode = .ByWordWrapping
        descriptionLabel.numberOfLines = 0
        self.contentView.addSubview(descriptionLabel)
        return descriptionLabel
    }()
    
    var tapGesture: UITapGestureRecognizer!
    var customView: UIView? {
        willSet {
            if let _ = customView {
                customView!.removeFromSuperview()
            }
        }
        didSet {
            if let _ = customView {
                customView!.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(customView!)
            }
        }
    }
    
    var verticalOffset: CGFloat!
    var verticalSpace: CGFloat!
    
    // MARK: - Helper
    private func removeAllConstraints() {
        contentView.removeConstraints(contentView.constraints)
        removeConstraints(constraints)
    }
    
    private func shouldShowImageView() -> Bool {
        return imageView.image != nil
    }
    
    private func shouldShowTitleLabel() -> Bool {
        return titleLabel.attributedText?.length > 0
    }
    
    private func shouldShowDescriptionLabel() -> Bool {
        return descriptionLabel.attributedText?.length > 0
    }
    
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(self.contentView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        frame = super.bounds
        UIView.animateWithDuration(0.25) { () -> Void in
            self.contentView.alpha = 1
        }
    }
    
    func resetEmptyDataView() {
        imageView.image = nil
        titleLabel.attributedText = nil
        descriptionLabel.attributedText = nil
        customView = nil
        
        removeAllConstraints()
    }
    
    // MARK: - Configuration
    func setConstraints() {
        let centerX = NSLayoutConstraint(item: contentView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: contentView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: verticalOffset)
        addConstraint(centerX)
        addConstraint(centerY)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[\(ViewStrings.contentView)]|", options: [], metrics: nil, views: [ViewStrings.contentView : contentView]))
        
        if let customView = customView {
            contentView.addConstraint(NSLayoutConstraint(item: customView, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1, constant: 0))
            contentView.addConstraint(NSLayoutConstraint(item: customView, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0))
            contentView.addConstraint(NSLayoutConstraint(item: customView, attribute: .Width, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: customView.frame.width))
            contentView.addConstraint(NSLayoutConstraint(item: customView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: customView.frame.height))
        } else {
            var viewStrings = [String]()
            var views = [String: UIView]()
            
            if shouldShowImageView() {
                let viewString = ViewStrings.imageView
                viewStrings.append(viewString)
                views[viewString] = imageView
                
                contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1, constant: 0))
            }
            
            if shouldShowTitleLabel() {
                let viewString = ViewStrings.titleLabel
                viewStrings.append(viewString)
                views[viewString] = titleLabel
                contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[\(ViewStrings.titleLabel)(>=0)]-|", options: [], metrics: nil, views: [ViewStrings.titleLabel : titleLabel]))
            } else {
                titleLabel.removeFromSuperview()
            }
            
            if shouldShowDescriptionLabel() {
                let viewString = ViewStrings.descriptionLabel
                viewStrings.append(viewString)
                views[viewString] = descriptionLabel
                contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[\(ViewStrings.descriptionLabel)(>=0)]-|", options: [], metrics: nil, views: [ViewStrings.descriptionLabel : descriptionLabel]))
            } else {
                descriptionLabel.removeFromSuperview()
            }
            
            var verticalFormat = String()
            for (index, viewString) in viewStrings.enumerate() {
                verticalFormat += "[\(viewString)]"
                if index != viewStrings.count - 1 {
                    verticalFormat += "-\(verticalSpace)-"
                }
            }
            
            if !verticalFormat.isEmpty {
                contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|\(verticalFormat)|", options: [], metrics: nil, views: views))
            }
        }
    }
}

// MARK: - TBEmptyDataSetDataSource
@objc protocol TBEmptyDataSetDataSource: NSObjectProtocol {
    optional func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage?
    optional func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString?
    optional func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString?
    
    optional func imageTintColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor?
    optional func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor?
    
    optional func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat
    optional func verticalSpaceForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat
    
    optional func customViewForEmptyDataSet(scrollView: UIScrollView!) -> UIView?
}

// MARK: - TBEmptyDataSetDelegate
@objc protocol TBEmptyDataSetDelegate: NSObjectProtocol {
    optional func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool
    optional func emptyDataSetTapEnabled(scrollView: UIScrollView!) -> Bool
    optional func emptyDataSetScrollEnabled(scrollView: UIScrollView!) -> Bool
    
    optional func emptyDataSetDidTapView(scrollView: UIScrollView!)
    
    optional func emptyDataSetWillAppear(scrollView: UIScrollView!)
    optional func emptyDataSetDidAppear(scrollView: UIScrollView!)
    optional func emptyDataSetWillDisappear(scrollView: UIScrollView!)
    optional func emptyDataSetDidDisappear(scrollView: UIScrollView!)
}

// MARK: - Extension
extension UIScrollView: UIGestureRecognizerDelegate {
    // MARK: - Structs
    private struct AssociatedKeys {
        static var emptyDataSetDataSource = "emptyDataSetDataSource"
        static var emptyDataSetDelegate = "emptyDataSetDelegate"
        static var emptyDataView = "emptyDataView"
    }
    
    private struct Selectors {
        static let dataSource: Selector = "dataSource"
        static let reloadData: Selector = "reloadData"
        static let endUpdates: Selector = "endUpdates"
        static let tableViewSwizzledReloadData: Selector = "tb_tableViewSwizzledReloadData"
        static let tableViewSwizzledEndUpdates: Selector = "tb_tableViewSwizzledEndUpdates"
        static let collectionViewSwizzledReloadData: Selector = "tb_collectionViewSwizzledReloadData"
    }
    
    private struct TableViewSelectors {
        static let dataSource: Selector = "dataSource"
        static let numberOfSections: Selector = "numberOfSectionsInTableView"
    }
    
    private struct CollectionViewSelectors {
        static let dataSource: Selector = "dataSource"
        static let numberOfSections: Selector = "numberOfSectionsInCollectionView"
    }
    
    private struct EmptyDataSetSelectors {
        static let image: Selector = "imageForEmptyDataSet:"
        static let title: Selector = "titleForEmptyDataSet:"
        static let description: Selector = "descriptionForEmptyDataSet:"
        static let imageTintColor: Selector = "imageTintColorForEmptyDataSet:"
        static let backgroundColor: Selector = "backgroundColorForEmptyDataSet:"
        static let verticalOffset: Selector = "verticalOffsetForEmptyDataSet:"
        static let verticalSpace: Selector = "verticalSpaceForEmptyDataSet:"
        static let customView: Selector = "customViewForEmptyDataSet:"
        
        static let shouldDisplay: Selector = "emptyDataSetShouldDisplay:"
        static let tapEnabled: Selector = "emptyDataSetTapEnabled:"
        static let scrollEnabled: Selector = "emptyDataSetScrollEnabled:"
        static let didTapView: Selector = "emptyDataSetDidTapView:"
        static let willAppear: Selector = "emptyDataSetWillAppear:"
        static let didAppear: Selector = "emptyDataSetDidAppear:"
        static let willDisappear: Selector = "emptyDataSetWillDisappear:"
        static let didDisappear: Selector = "emptyDataSetDidDisappear:"
    }
    
    private struct DefaultValues {
        static let verticalOffset: CGFloat = 0
        static let verticalSpace: CGFloat = 12
    }
    
    // MARK: - Properties
    var emptyDataSetDataSource: TBEmptyDataSetDataSource? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.emptyDataSetDataSource) as? TBEmptyDataSetDataSource
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.emptyDataSetDataSource, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                swizzleMethod(selector: Selectors.reloadData)
                if isKindOfClass(UITableView.self) {
                    swizzleMethod(selector: Selectors.endUpdates)
                }
            } else {
                handlingInvalidEmptyDataSet()
            }
        }
    }
    
    var emptyDataSetDelegate: TBEmptyDataSetDelegate? {
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
    
    var emptyDataViewVisible: Bool {
        get {
            if let emptyDataView = objc_getAssociatedObject(self, &AssociatedKeys.emptyDataView) as? EmptyDataView {
                return emptyDataView.hidden
            }
            return false
        }
    }
    
    private var emptyDataView: EmptyDataView! {
        get {
            var emptyDataView = objc_getAssociatedObject(self, &AssociatedKeys.emptyDataView) as? EmptyDataView
            if emptyDataView == nil {
                emptyDataView = EmptyDataView(frame: frame)
                emptyDataView!.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
                emptyDataView!.hidden = true
                
                emptyDataView!.tapGesture = UITapGestureRecognizer(target: self, action: "didTapEmptyDataView:")
                emptyDataView!.tapGesture.delegate = self
                emptyDataView!.addGestureRecognizer(emptyDataView!.tapGesture)
                setEmptyDataView(emptyDataView!)
            }
            return emptyDataView!
        }
    }
    
    // MARK: - Setters
    private func setEmptyDataView(emptyDataView: EmptyDataView?) {
        objc_setAssociatedObject(self, &AssociatedKeys.emptyDataView, emptyDataView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    // MARK: - DataSource getters
    private func dataSourceSelectorAvailable(selector selector: Selector) -> Bool {
        if let _ = emptyDataSetDataSource {
            return emptyDataSetDataSource!.respondsToSelector(selector)
        }
        return false
    }
    
    private func emptyDataSetImage() -> UIImage? {
        let selector = EmptyDataSetSelectors.image
        if dataSourceSelectorAvailable(selector: selector) {
            if let image = emptyDataSetDataSource!.imageForEmptyDataSet!(self) {
                assert(image.isKindOfClass(UIImage.self), "Must return a valid UIImage instance for \(selector.description)")
                return image
            }
        }
        return nil
    }
    
    private func emptyDataSetTitle() -> NSAttributedString? {
        let selector = EmptyDataSetSelectors.title
        if dataSourceSelectorAvailable(selector: selector) {
            if let title = emptyDataSetDataSource!.titleForEmptyDataSet!(self) {
                assert(title.isKindOfClass(NSAttributedString.self), "Must return a valid NSAttributedString instance for \(selector.description)")
                return title
            }
        }
        return nil
    }
    
    private func emptyDataSetDescription() -> NSAttributedString? {
        let selector = EmptyDataSetSelectors.description
        if dataSourceSelectorAvailable(selector: selector) {
            if let description = emptyDataSetDataSource!.descriptionForEmptyDataSet!(self) {
                assert(description.isKindOfClass(NSAttributedString.self), "Must return a valid NSAttributedString instance for \(selector.description)")
                return description
            }
        }
        return nil
    }
    
    private func emptyDataSetImageTintColor() -> UIColor? {
        let selector = EmptyDataSetSelectors.imageTintColor
        if dataSourceSelectorAvailable(selector: selector) {
            if let imageTintColor = emptyDataSetDataSource!.imageTintColorForEmptyDataSet!(self) {
                assert(imageTintColor.isKindOfClass(UIColor.self), "Must return a valid UIColor instance for \(selector.description)")
                return imageTintColor
            }
        }
        return nil
    }
    
    private func emptyDataSetBackgroundColor() -> UIColor? {
        let selector = EmptyDataSetSelectors.backgroundColor
        if dataSourceSelectorAvailable(selector: selector) {
            if let backgroundColor = emptyDataSetDataSource!.backgroundColorForEmptyDataSet!(self) {
                assert(backgroundColor.isKindOfClass(UIColor.self), "Must return a valid UIColor instance for \(selector.description)")
                return backgroundColor
            }
        }
        return nil
    }
    
    private func emptyDataSetVerticalOffset() -> CGFloat {
        let selector = EmptyDataSetSelectors.verticalOffset
        if dataSourceSelectorAvailable(selector: selector) {
            let verticalOffset = emptyDataSetDataSource!.verticalOffsetForEmptyDataSet!(self)
            return verticalOffset
        }
        return DefaultValues.verticalOffset
    }
    
    private func emptyDataSetVerticalSpace() -> CGFloat {
        let selector = EmptyDataSetSelectors.verticalSpace
        if dataSourceSelectorAvailable(selector: selector) {
            let verticalSpace = emptyDataSetDataSource!.verticalSpaceForEmptyDataSet!(self)
            return verticalSpace
        }
        return DefaultValues.verticalSpace
    }
    
    private func emptyDataSetCustomView() -> UIView? {
        let selector = EmptyDataSetSelectors.customView
        if dataSourceSelectorAvailable(selector: selector) {
            if let customView = emptyDataSetDataSource!.customViewForEmptyDataSet!(self) {
                assert(customView.isKindOfClass(UIView.self), "Must return a valid UIView instance for \(selector.description)")
                return customView
            }
        }
        return nil
    }
    
    // MARK: - Delegate getters
    private func delegateSelectorAvailable(selector selector: Selector) -> Bool {
        if let _ = emptyDataSetDelegate {
            return emptyDataSetDelegate!.respondsToSelector(selector)
        }
        return false
    }
    
    private func emptyDataSetShouldDisplay() -> Bool {
        let selector = EmptyDataSetSelectors.shouldDisplay
        if delegateSelectorAvailable(selector: selector) {
            return emptyDataSetDelegate!.emptyDataSetShouldDisplay!(self)
        }
        return true
    }
    
    private func emptyDataSetTapEnabled() -> Bool {
        let selector = EmptyDataSetSelectors.tapEnabled
        if delegateSelectorAvailable(selector: selector) {
            return emptyDataSetDelegate!.emptyDataSetTapEnabled!(self)
        }
        return true
    }
    
    private func emptyDataSetScrollEnabled() -> Bool {
        let selector = EmptyDataSetSelectors.scrollEnabled
        if delegateSelectorAvailable(selector: selector) {
            return emptyDataSetDelegate!.emptyDataSetScrollEnabled!(self)
        }
        return false
    }
    
    // MARK: - View events
    func didTapEmptyDataView(sender: AnyObject) {
        let selector = EmptyDataSetSelectors.didTapView
        if delegateSelectorAvailable(selector: selector) {
            emptyDataSetDelegate!.emptyDataSetDidTapView!(self)
        }
    }
    
    private func emptyDataSetWillAppear() {
        let selector = EmptyDataSetSelectors.willAppear
        if delegateSelectorAvailable(selector: selector) {
            emptyDataSetDelegate!.emptyDataSetWillAppear!(self)
        }
    }
    
    private func emptyDataSetDidAppear() {
        let selector = EmptyDataSetSelectors.didAppear
        if delegateSelectorAvailable(selector: selector) {
            emptyDataSetDelegate!.emptyDataSetDidAppear!(self)
        }
    }
    
    private func emptyDataSetWillDisappear() {
        let selector = EmptyDataSetSelectors.willDisappear
        if delegateSelectorAvailable(selector: selector) {
            emptyDataSetDelegate!.emptyDataSetWillDisappear!(self)
        }
    }
    
    private func emptyDataSetDidDisappear() {
        let selector = EmptyDataSetSelectors.didDisappear
        if delegateSelectorAvailable(selector: selector) {
            emptyDataSetDelegate!.emptyDataSetDidDisappear!(self)
        }
    }
    
    // MARK: - Helper
    private func emptyDataSetAvailable() -> Bool {
        if let _ = emptyDataSetDataSource {
            return isKindOfClass(UITableView.self) || isKindOfClass(UICollectionView.self) || isKindOfClass(UIScrollView.self)
        }
        return false
    }
    
    private func cellsCount() -> Int {
        if !self.respondsToSelector(Selectors.dataSource) {
            return 0
        }
        
        var count = 0
        if isKindOfClass(UITableView.self) {
            let tableView = self as! UITableView
            if let dataSource = tableView.dataSource {
                if dataSource.respondsToSelector(TableViewSelectors.numberOfSections) {
                    let sections = dataSource.numberOfSectionsInTableView!(tableView)
                    for section in 0...sections - 1 {
                        count += dataSource.tableView(tableView, numberOfRowsInSection: section)
                    }
                }
            }
        } else if isKindOfClass(UICollectionView.self) {
            let collectionView = self as! UICollectionView
            if let dataSource = collectionView.dataSource {
                if dataSource.respondsToSelector(CollectionViewSelectors.numberOfSections) {
                    let sections = dataSource.numberOfSectionsInCollectionView!(collectionView)
                    for section in 0...sections - 1 {
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
            addSubview(emptyDataView)
            bringSubviewToFront(emptyDataView)
        }
        emptyDataView.resetEmptyDataView()
        
        emptyDataView!.verticalOffset = emptyDataSetVerticalOffset()
        emptyDataView!.verticalSpace = emptyDataSetVerticalSpace()
        
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
        emptyDataView.userInteractionEnabled = emptyDataSetTapEnabled()
        scrollEnabled = emptyDataSetScrollEnabled()
        
        emptyDataView.setConstraints()
        emptyDataView.layoutIfNeeded()
        
        emptyDataSetDidAppear()
    }
    
    // MARK: - Method swizzling
    private func swizzleMethod(selector selector: Selector) {
        struct SwizzledInfo {
            static var methods: [String] = Array()
        }
        
        func swizzle(swizzledSelector swizzledSelector: Selector) {
            let originalSelector = selector
            let originalMethod = class_getInstanceMethod(self.dynamicType, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self.dynamicType, swizzledSelector)
            
            let className = NSStringFromClass(self.dynamicType)
            let selectorName = NSStringFromSelector(originalSelector)
            let method = className + "_" + selectorName
            if SwizzledInfo.methods.contains(method) {
                print("\(method) has already been swizzled!")
                return
            } else {
                SwizzledInfo.methods.append(method)
            }
            
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        
        if !respondsToSelector(selector) {
            return
        }
        
        if self.isKindOfClass(UITableView.self) {
            var swizzledSelector: Selector?
            if selector == Selectors.reloadData {
                swizzledSelector = Selectors.tableViewSwizzledReloadData
            } else if selector == Selectors.endUpdates {
                swizzledSelector = Selectors.tableViewSwizzledEndUpdates
            }
            
            if let _ = swizzledSelector {
                swizzle(swizzledSelector: swizzledSelector!)
            } else {
                return
            }
        } else if self.isKindOfClass(UICollectionView.self) {
            swizzle(swizzledSelector: Selectors.collectionViewSwizzledReloadData)
        } else {
            return
        }
    }
    
    public func tb_tableViewSwizzledReloadData() {
        tb_tableViewSwizzledReloadData()
        reloadEmptyDataSet()
        print("\(__FUNCTION__)")
    }
    
    public func tb_tableViewSwizzledEndUpdates() {
        tb_tableViewSwizzledEndUpdates()
        reloadEmptyDataSet()
        print("\(__FUNCTION__)")
    }
    
    public func tb_collectionViewSwizzledReloadData() {
        tb_collectionViewSwizzledReloadData()
        reloadEmptyDataSet()
        print("\(__FUNCTION__)")
    }
}

