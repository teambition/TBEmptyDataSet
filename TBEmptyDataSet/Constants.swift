//
//  Constants.swift
//  TBEmptyDataSet
//
//  Created by Xin Hong on 15/11/19.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

// swiftlint:disable variable_name
internal struct AssociatedKeys {
    static var emptyDataSetDataSource = "emptyDataSetDataSource"
    static var emptyDataSetDelegate = "emptyDataSetDelegate"
    static var emptyDataView = "emptyDataView"
}

internal struct Selectors {
    static let tableViewSwizzledReloadData = #selector(UIScrollView.tb_tableViewSwizzledReloadData)
    static let tableViewSwizzledEndUpdates = #selector(UIScrollView.tb_tableViewSwizzledEndUpdates)
    static let collectionViewSwizzledReloadData = #selector(UIScrollView.tb_collectionViewSwizzledReloadData)
    static let collectionViewSwizzledPerformBatchUpdates = #selector(UIScrollView.tb_collectionViewSwizzledPerformBatchUpdates(_:completion:))
}

internal struct TableViewSelectors {
    static let reloadData = #selector(UITableView.reloadData)
    static let endUpdates = #selector(UITableView.endUpdates)
    static let numberOfSections = #selector(UITableViewDataSource.numberOfSections(in:))
}

internal struct CollectionViewSelectors {
    static let reloadData = #selector(UICollectionView.reloadData)
    static let numberOfSections = #selector(UICollectionViewDataSource.numberOfSections(in:))
    static let performBatchUpdates = #selector(UICollectionView.performBatchUpdates(_:completion:))
}

internal struct DefaultValues {
    static let verticalOffset: CGFloat = 0
    static let verticalSpace: CGFloat = 12
    static let verticalSpaces = [verticalSpace, verticalSpace]
    static let titleMargin: CGFloat = 15
    static let descriptionMargin: CGFloat = 15
}
