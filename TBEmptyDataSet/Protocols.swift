//
//  Protocols.swift
//  TBEmptyDataSet
//
//  Created by Xin Hong on 15/11/19.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

public protocol TBEmptyDataSetDataSource {
    func imageForEmptyDataSet(in scrollView: UIScrollView) -> UIImage?
    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString?
    func descriptionForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString?

    func imageTintColorForEmptyDataSet(in scrollView: UIScrollView) -> UIColor?
    func backgroundColorForEmptyDataSet(in scrollView: UIScrollView) -> UIColor?

    func verticalOffsetForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat
    func verticalSpacesForEmptyDataSet(in scrollView: UIScrollView) -> [CGFloat]
    func titleMarginForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat
    func descriptionMarginForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat

    func customViewForEmptyDataSet(in scrollView: UIScrollView) -> UIView?
}

public protocol TBEmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(in scrollView: UIScrollView) -> Bool
    func emptyDataSetTapEnabled(in scrollView: UIScrollView) -> Bool
    func emptyDataSetScrollEnabled(in scrollView: UIScrollView) -> Bool

    func emptyDataSetDidTapEmptyView(in scrollView: UIScrollView)

    func emptyDataSetWillAppear(in scrollView: UIScrollView)
    func emptyDataSetDidAppear(in scrollView: UIScrollView)
    func emptyDataSetWillDisappear(in scrollView: UIScrollView)
    func emptyDataSetDidDisappear(in scrollView: UIScrollView)
}

public extension TBEmptyDataSetDataSource {
    func imageForEmptyDataSet(in scrollView: UIScrollView) -> UIImage? {
        return nil
    }

    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        return nil
    }

    func descriptionForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        return nil
    }

    func imageTintColorForEmptyDataSet(in scrollView: UIScrollView) -> UIColor? {
        return nil
    }

    func backgroundColorForEmptyDataSet(in scrollView: UIScrollView) -> UIColor? {
        return nil
    }

    func verticalOffsetForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat {
        return DefaultValues.verticalOffset
    }

    func verticalSpacesForEmptyDataSet(in scrollView: UIScrollView) -> [CGFloat] {
        return DefaultValues.verticalSpaces
    }

    func titleMarginForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat {
        return DefaultValues.titleMargin
    }

    func descriptionMarginForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat {
        return DefaultValues.descriptionMargin
    }

    func customViewForEmptyDataSet(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}

public extension TBEmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(in scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetTapEnabled(in scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetScrollEnabled(in scrollView: UIScrollView) -> Bool {
        return false
    }

    func emptyDataSetDidTapEmptyView(in scrollView: UIScrollView) {

    }

    func emptyDataSetWillAppear(in scrollView: UIScrollView) {

    }

    func emptyDataSetDidAppear(in scrollView: UIScrollView) {

    }

    func emptyDataSetWillDisappear(in scrollView: UIScrollView) {

    }

    func emptyDataSetDidDisappear(in scrollView: UIScrollView) {

    }
}
