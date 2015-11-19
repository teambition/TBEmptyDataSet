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
    var view: UIView!
    var imageView: UIImageView?
    var titleLabel: UILabel?
    var descriptionLabel: UILabel?
    
    var tapGesture: UITapGestureRecognizer!
    
    var customView: UIView?
}

// MARK: - TBEmptyDataSetDataSource
protocol TBEmptyDataSetDataSource: NSObjectProtocol {
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString
    
    func imageTintColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor
    
    func customViewForEmptyDataSet(scrollView: UIScrollView!) -> UIView
}

// MARK: - TBEmptyDataSetDelegate
protocol TBEmptyDataSetDelegate: NSObjectProtocol {
    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool
    func emptyDataSetTapEnabled(scrollView: UIScrollView!) -> Bool
    func emptyDataSetScrollEnabled(scrollView: UIScrollView!) -> Bool
    
    func emptyDataSetDidTapView(scrollView: UIScrollView!)
    
    func emptyDataSetWillAppear(scrollView: UIScrollView!)
    func emptyDataSetDidAppear(scrollView: UIScrollView!)
    func emptyDataSetWillDisappear(scrollView: UIScrollView!)
    func emptyDataSetDidDisappear(scrollView: UIScrollView!)
}

extension UIScrollView: UIGestureRecognizerDelegate {
    // MARK: - Structs
    private struct Screen {
        static let width = UIScreen.mainScreen().bounds.width
        static let height = UIScreen.mainScreen().bounds.height
    }
    
    private struct AssociatedKeys {
        static let emptyDataSetDataSource = "emptyDataSetDataSource"
        static let emptyDataSetDelegate = "emptyDataSetDelegate"
        static let emptyDataView = "emptyDataView"
    }
    
    private struct Selectors {
        static let dataSource: Selector = "dataSource"
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
    
    // MARK: - Properties
    var emptyDataSetDataSource: TBEmptyDataSetDataSource? {
        get {
            return objc_getAssociatedObject(self, AssociatedKeys.emptyDataSetDataSource) as? TBEmptyDataSetDataSource
        }
    }
    
    var emptyDataSetDelegate: TBEmptyDataSetDelegate? {
        get {
            return objc_getAssociatedObject(self, AssociatedKeys.emptyDataSetDelegate) as? TBEmptyDataSetDelegate
        }
    }
    
    var emptyDataViewVisible: Bool? {
        get {
            if let emptyDataView = objc_getAssociatedObject(self, AssociatedKeys.emptyDataView) as? EmptyDataView {
                return emptyDataView.hidden
            }
            return false
        }
    }
    
    private var emptyDataView: EmptyDataView! {
        get {
            var emptyDataView = objc_getAssociatedObject(self, AssociatedKeys.emptyDataView) as? EmptyDataView
            if emptyDataView == nil {
                emptyDataView = EmptyDataView()
                emptyDataView!.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
                emptyDataView!.hidden = true
                
                emptyDataView!.tapGesture = UITapGestureRecognizer(target: self, action: "didTapEmptyDataView:")
                emptyDataView!.tapGesture.delegate = self
                setEmptyDataView(emptyDataView!)
            }
            
            return emptyDataView!
        }
    }
    
    // MARK: - Setters
    private func setEmptyDataView(emptyDataView: EmptyDataView) {
        objc_setAssociatedObject(self, AssociatedKeys.emptyDataView, emptyDataView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
            let image = emptyDataSetDataSource!.imageForEmptyDataSet(self)
            assert(image.isKindOfClass(UIImage.self), "Must return a valid UIImage instance for \(selector.description)")
            return image
        }
        
        return nil
    }
    
    private func emptyDataSetTitle() -> NSAttributedString? {
        let selector = EmptyDataSetSelectors.title
        if dataSourceSelectorAvailable(selector: selector) {
            let title = emptyDataSetDataSource!.titleForEmptyDataSet(self)
            assert(title.isKindOfClass(NSAttributedString.self), "Must return a valid NSAttributedString instance for \(selector.description)")
            return title
        }
        
        return nil
    }
    
    private func emptyDataSetDescription() -> NSAttributedString? {
        let selector = EmptyDataSetSelectors.description
        if dataSourceSelectorAvailable(selector: selector) {
            let description = emptyDataSetDataSource!.descriptionForEmptyDataSet(self)
            assert(description.isKindOfClass(NSAttributedString.self), "Must return a valid NSAttributedString instance for \(selector.description)")
            return description
        }
        
        return nil
    }
    
    private func emptyDataSetImageTintColor() -> UIColor? {
        let selector = EmptyDataSetSelectors.imageTintColor
        if dataSourceSelectorAvailable(selector: selector) {
            let imageTintColor = emptyDataSetDataSource!.imageTintColorForEmptyDataSet(self)
            assert(imageTintColor.isKindOfClass(UIColor.self), "Must return a valid UIColor instance for \(selector.description)")
            return imageTintColor
        }
        
        return nil
    }
    
    private func emptyDataSetBackgroundColor() -> UIColor? {
        let selector = EmptyDataSetSelectors.backgroundColor
        if dataSourceSelectorAvailable(selector: selector) {
            let backgroundColor = emptyDataSetDataSource!.backgroundColorForEmptyDataSet(self)
            assert(backgroundColor.isKindOfClass(UIColor.self), "Must return a valid UIColor instance for \(selector.description)")
            return backgroundColor
        }
        
        return nil
    }
    
    private func emptyDataSetCustomView() -> UIView? {
        let selector = EmptyDataSetSelectors.customView
        if dataSourceSelectorAvailable(selector: selector) {
            let customView = emptyDataSetDataSource!.customViewForEmptyDataSet(self)
            assert(customView.isKindOfClass(UIColor.self), "Must return a valid UIView instance for \(selector.description)")
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
            return emptyDataSetDelegate!.emptyDataSetShouldDisplay(self)
        }
        
        return true
    }
    
    private func emptyDataSetTapEnabled() -> Bool {
        let selector = EmptyDataSetSelectors.tapEnabled
        if delegateSelectorAvailable(selector: selector) {
            return emptyDataSetDelegate!.emptyDataSetTapEnabled(self)
        }
        
        return true
    }
    
    private func emptyDataSetScrollEnabled() -> Bool {
        let selector = EmptyDataSetSelectors.scrollEnabled
        if delegateSelectorAvailable(selector: selector) {
            return emptyDataSetDelegate!.emptyDataSetScrollEnabled(self)
        }
        
        return false
    }
    
    // MARK: - View events
    private func didTapEmptyDataView(sender: AnyObject) {
        let selector = EmptyDataSetSelectors.didTapView
        if delegateSelectorAvailable(selector: selector) {
            emptyDataSetDelegate!.emptyDataSetDidTapView(self)
        }
    }
    
    private func emptyDataSetWillAppear() {
        let selector = EmptyDataSetSelectors.willAppear
        if delegateSelectorAvailable(selector: selector) {
            emptyDataSetDelegate!.emptyDataSetWillAppear(self)
        }
    }
    
    private func emptyDataSetDidAppear() {
        let selector = EmptyDataSetSelectors.didAppear
        if delegateSelectorAvailable(selector: selector) {
            emptyDataSetDelegate!.emptyDataSetDidAppear(self)
        }
    }
    
    private func emptyDataSetWillDisappear() {
        let selector = EmptyDataSetSelectors.willDisappear
        if delegateSelectorAvailable(selector: selector) {
            emptyDataSetDelegate!.emptyDataSetWillDisappear(self)
        }
    }
    
    private func emptyDataSetDidDisappear() {
        let selector = EmptyDataSetSelectors.didDisappear
        if delegateSelectorAvailable(selector: selector) {
            emptyDataSetDelegate!.emptyDataSetDidDisappear(self)
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
            let dataSource = performSelector(TableViewSelectors.dataSource) as! UITableViewDataSource
            
            if dataSource.respondsToSelector(TableViewSelectors.numberOfSections) {
                let sections = dataSource.numberOfSectionsInTableView!(tableView)
                for section in 0...sections - 1 {
                    count += dataSource.tableView(tableView, numberOfRowsInSection: section)
                }
            }
        } else if isKindOfClass(UICollectionView.self) {
            let collectionView = self as! UICollectionView
            let dataSource = performSelector(CollectionViewSelectors.dataSource) as! UICollectionViewDataSource
            
            if dataSource.respondsToSelector(CollectionViewSelectors.numberOfSections) {
                let sections = dataSource.numberOfSectionsInCollectionView!(collectionView)
                for section in 0...sections - 1 {
                    count += dataSource.collectionView(collectionView, numberOfItemsInSection: section)
                }
            }
        }
        
        return count
    }
}

