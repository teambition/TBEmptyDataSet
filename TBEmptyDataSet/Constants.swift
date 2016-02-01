//
//  Constants.swift
//  TBEmptyDataSet
//
//  Created by Xin Hong on 15/11/19.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

struct AssociatedKeys {
    static var emptyDataSetDataSource = "emptyDataSetDataSource"
    static var emptyDataSetDelegate = "emptyDataSetDelegate"
    static var emptyDataView = "emptyDataView"
}

struct Selectors {
    static let dataSource: Selector = "dataSource"
    static let reloadData: Selector = "reloadData"
    static let endUpdates: Selector = "endUpdates"
    static let tableViewSwizzledReloadData: Selector = "tb_tableViewSwizzledReloadData"
    static let tableViewSwizzledEndUpdates: Selector = "tb_tableViewSwizzledEndUpdates"
    static let collectionViewSwizzledReloadData: Selector = "tb_collectionViewSwizzledReloadData"
}

struct TableViewSelectors {
    static let dataSource: Selector = "dataSource"
    static let numberOfSections: Selector = "numberOfSectionsInTableView:"
}

struct CollectionViewSelectors {
    static let dataSource: Selector = "dataSource"
    static let numberOfSections: Selector = "numberOfSectionsInCollectionView:"
}

struct DefaultValues {
    static let verticalOffset: CGFloat = 0
    static let verticalSpace: CGFloat = 12
}
