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
    static let tableViewSwizzledReloadData = #selector(UIScrollView.tb_tableViewSwizzledReloadData)
    static let tableViewSwizzledEndUpdates = #selector(UIScrollView.tb_tableViewSwizzledEndUpdates)
    static let collectionViewSwizzledReloadData = #selector(UIScrollView.tb_collectionViewSwizzledReloadData)
}

struct TableViewSelectors {
    static let reloadData = #selector(UITableView.reloadData)
    static let endUpdates = #selector(UITableView.endUpdates)
    static let numberOfSections = #selector(UITableViewDataSource.numberOfSectionsInTableView(_:))
}

struct CollectionViewSelectors {
    static let reloadData = #selector(UICollectionView.reloadData)
    static let numberOfSections = #selector(UICollectionViewDataSource.numberOfSectionsInCollectionView(_:))
}

struct DefaultValues {
    static let verticalOffset: CGFloat = 0
    static let verticalSpace: CGFloat = 12
}
