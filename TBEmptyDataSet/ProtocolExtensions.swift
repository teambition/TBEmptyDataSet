//
//  ProtocolExtensions.swift
//  TBEmptyDataSet
//
//  Created by Xin Hong on 15/11/19.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

public extension TBEmptyDataSetDataSource {
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage? {
        return nil
    }

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString? {
        return nil
    }

    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString? {
        return nil
    }

    func imageTintColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor? {
        return nil
    }

    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor? {
        return nil
    }

    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return DefaultValues.verticalOffset
    }

    func verticalSpaceForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return DefaultValues.verticalSpace
    }

    func customViewForEmptyDataSet(scrollView: UIScrollView!) -> UIView? {
        return nil
    }
}

public extension TBEmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
        return true
    }

    func emptyDataSetTapEnabled(scrollView: UIScrollView!) -> Bool {
        return true
    }

    func emptyDataSetScrollEnabled(scrollView: UIScrollView!) -> Bool {
        return false
    }

    func emptyDataSetDidTapView(scrollView: UIScrollView!) {

    }

    func emptyDataSetWillAppear(scrollView: UIScrollView!) {

    }

    func emptyDataSetDidAppear(scrollView: UIScrollView!) {

    }

    func emptyDataSetWillDisappear(scrollView: UIScrollView!) {

    }

    func emptyDataSetDidDisappear(scrollView: UIScrollView!) {

    }
}
