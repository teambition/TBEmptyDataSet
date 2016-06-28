//
//  Constants.swift
//  TBEmptyDataSet
//
//  Created by Xin Hong on 15/11/19.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

// swiftlint:disable variable_name
struct AssociatedKeys {
    static var emptyDataSetDataSource = "emptyDataSetDataSource"
    static var emptyDataSetDelegate = "emptyDataSetDelegate"
    static var emptyDataView = "emptyDataView"
}

struct Selectors {
    static let tableViewSwizzledReloadData = #selector(UIScrollView.tb_tableViewSwizzledReloadData)
    static let tableViewSwizzledEndUpdates = #selector(UIScrollView.tb_tableViewSwizzledEndUpdates)
    static let collectionViewSwizzledReloadData = #selector(UIScrollView.tb_collectionViewSwizzledReloadData)
    static let collectionViewSwizzledPerformBatchUpdates = #selector(UIScrollView.tb_collectionViewSwizzledPerformBatchUpdates(_:completion:))
}

struct TableViewSelectors {
    static let reloadData = #selector(UITableView.reloadData)
    static let endUpdates = #selector(UITableView.endUpdates)
    static let numberOfSections = #selector(UITableViewDataSource.numberOfSectionsInTableView(_:))
}

struct CollectionViewSelectors {
    static let reloadData = #selector(UICollectionView.reloadData)
    static let numberOfSections = #selector(UICollectionViewDataSource.numberOfSectionsInCollectionView(_:))
    static let performBatchUpdates = #selector(UICollectionView.performBatchUpdates(_:completion:))
}

struct DefaultValues {
    static let verticalOffset: CGFloat = 0
    static let verticalSpace: CGFloat = 12
}
