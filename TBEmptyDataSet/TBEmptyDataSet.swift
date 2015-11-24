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
        static let view = "view"
        static let imageView = "imageView"
        static let titleLabel = "titleLabel"
        static let descriptionLabel = "descriptionLabel"
        static let customView = "customView"
    }
    
    // MARK: - Properties
    lazy var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clearColor()
        view.userInteractionEnabled = true
        view.alpha = 0
        return view
    }()
    
    lazy var imageView: UIImageView = { [unowned self] in
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clearColor()
        imageView.contentMode = .ScaleAspectFill
        imageView.userInteractionEnabled = false
        self.view.addSubview(imageView)
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
        self.view.addSubview(titleLabel)
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
        self.view.addSubview(descriptionLabel)
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
                view.addSubview(customView!)
            }
        }
    }
    
    var verticalOffset: CGFloat!
    var verticalSpace: CGFloat!
    
    // MARK: - Helper
    private func removeAllConstraints() {
        view.removeConstraints(view.constraints)
        removeConstraints(constraints)
    }
    
    private func shouldShowImageView() -> Bool {
        if let _ = imageView.superview {
            return true
        }
        return false
    }
    
    private func shouldShowTitleLabel() -> Bool {
        if let _ = titleLabel.superview {
            return titleLabel.attributedText?.length > 0
        }
        return false
    }
    
    private func shouldShowDescriptionLabel() -> Bool {
        if let _ = descriptionLabel.superview {
            return descriptionLabel.attributedText?.length > 0
        }
        return false
    }
    
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(self.view)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        frame = super.bounds
        UIView.animateWithDuration(0.25) { () -> Void in
            self.view.alpha = 1
        }
    }
    
    func resetEmptyDataView() {
        view.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        customView = nil
        removeAllConstraints()
    }
    
    // MARK: - Configuration
    func setConstraints() {
        let centerX = NSLayoutConstraint(item: view, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: view, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: verticalOffset)
        addConstraint(centerX)
        addConstraint(centerY)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[\(ViewStrings.view)]|", options: [], metrics: nil, views: [ViewStrings.view : view]))
        
        if let _ = customView {
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[\(ViewStrings.customView)]|", options: [], metrics: nil, views: [ViewStrings.customView : customView!]))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[\(ViewStrings.customView)]|", options: [], metrics: nil, views: [ViewStrings.customView : customView!]))
        } else {
            var viewStrings = [String]()
            var views = [String: UIView]()
            
            if shouldShowImageView() {
                let viewString = ViewStrings.imageView
                viewStrings.append(viewString)
                views[viewString] = imageView
                
                view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
            }
            
            if shouldShowTitleLabel() {
                let viewString = ViewStrings.titleLabel
                viewStrings.append(viewString)
                views[viewString] = titleLabel
                view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[\(ViewStrings.titleLabel)(>=0)]-|", options: [], metrics: nil, views: [ViewStrings.titleLabel : titleLabel]))
            } else {
                titleLabel.removeFromSuperview()
            }
            
            if shouldShowDescriptionLabel() {
                let viewString = ViewStrings.descriptionLabel
                viewStrings.append(viewString)
                views[viewString] = descriptionLabel
                view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[\(ViewStrings.descriptionLabel)(>=0)]-|", options: [], metrics: nil, views: [ViewStrings.descriptionLabel : descriptionLabel]))
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
                view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|\(verticalFormat)|", options: [], metrics: nil, views: views))
            }
        }
    }
}

// MARK: - TBEmptyDataSetDataSource
@objc protocol TBEmptyDataSetDataSource: NSObjectProtocol {
    optional func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage
    optional func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString
    optional func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString
    
    optional func imageTintColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor
    optional func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor
    
    optional func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat
    optional func verticalSpaceForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat
    
    optional func customViewForEmptyDataSet(scrollView: UIScrollView!) -> UIView
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
        static let swizzledReloadData: Selector = "tb_swizzledReloadData"
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
                
                swizzleReloadData()
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
            let image = emptyDataSetDataSource!.imageForEmptyDataSet!(self)
            assert(image.isKindOfClass(UIImage.self), "Must return a valid UIImage instance for \(selector.description)")
            return image
        }
        
        return nil
    }
    
    private func emptyDataSetTitle() -> NSAttributedString? {
        let selector = EmptyDataSetSelectors.title
        if dataSourceSelectorAvailable(selector: selector) {
            let title = emptyDataSetDataSource!.titleForEmptyDataSet!(self)
            assert(title.isKindOfClass(NSAttributedString.self), "Must return a valid NSAttributedString instance for \(selector.description)")
            return title
        }
        
        return nil
    }
    
    private func emptyDataSetDescription() -> NSAttributedString? {
        let selector = EmptyDataSetSelectors.description
        if dataSourceSelectorAvailable(selector: selector) {
            let description = emptyDataSetDataSource!.descriptionForEmptyDataSet!(self)
            assert(description.isKindOfClass(NSAttributedString.self), "Must return a valid NSAttributedString instance for \(selector.description)")
            return description
        }
        
        return nil
    }
    
    private func emptyDataSetImageTintColor() -> UIColor? {
        let selector = EmptyDataSetSelectors.imageTintColor
        if dataSourceSelectorAvailable(selector: selector) {
            let imageTintColor = emptyDataSetDataSource!.imageTintColorForEmptyDataSet!(self)
            assert(imageTintColor.isKindOfClass(UIColor.self), "Must return a valid UIColor instance for \(selector.description)")
            return imageTintColor
        }
        
        return nil
    }
    
    private func emptyDataSetBackgroundColor() -> UIColor? {
        let selector = EmptyDataSetSelectors.backgroundColor
        if dataSourceSelectorAvailable(selector: selector) {
            let backgroundColor = emptyDataSetDataSource!.backgroundColorForEmptyDataSet!(self)
            assert(backgroundColor.isKindOfClass(UIColor.self), "Must return a valid UIColor instance for \(selector.description)")
            return backgroundColor
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
            let customView = emptyDataSetDataSource!.customViewForEmptyDataSet!(self)
            assert(customView.isKindOfClass(UIView.self), "Must return a valid UIView instance for \(selector.description)")
            return customView
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
        
        if let customView = emptyDataSetCustomView() {
            emptyDataView.customView = customView
        } else {
            emptyDataView!.verticalOffset = emptyDataSetVerticalOffset()
            emptyDataView!.verticalSpace = emptyDataSetVerticalSpace()
            
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
    private func swizzleReloadData() {
        struct tb_swizzleToken {
            static var onceToken: dispatch_once_t = 0
        }
        
        if !respondsToSelector(Selectors.reloadData) {
            return
        }
        
        dispatch_once(&tb_swizzleToken.onceToken) { () -> Void in
            var currentClass: AnyClass
            if self.isKindOfClass(UITableView.self) {
                currentClass = UITableView.self
            } else if self.isKindOfClass(UICollectionView.self) {
                currentClass = UICollectionView.self
            } else {
                return
            }
            
            let originalSelector = Selectors.reloadData
            let swizzledSelector = Selectors.swizzledReloadData
            let originalMethod = class_getInstanceMethod(currentClass, originalSelector)
            let swizzledMethod = class_getInstanceMethod(currentClass, swizzledSelector)
            
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    public func tb_swizzledReloadData() {
        // tb_swizzledReloadData here is actually the original method reloadData, although it seems like recursive.
        tb_swizzledReloadData()
        
        reloadEmptyDataSet()
    }
}

