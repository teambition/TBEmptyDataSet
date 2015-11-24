//
//  EmptyDataDemoTableViewController.swift
//  TBEmptyDataSet
//
//  Created by 洪鑫 on 15/11/24.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

private struct CellIdentifier {
    static let reuseIdentifier = "Cell"
}

class EmptyDataDemoTableViewController: UITableViewController, TBEmptyDataSetDataSource, TBEmptyDataSetDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "EmptyData TableView"
        tableView.tableFooterView = UIView()
        refreshControl?.addTarget(self, action: "fetchData:", forControlEvents: .ValueChanged)
        
        tableView.emptyDataSetDataSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    func fetchData(sender: AnyObject) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            self.refreshControl?.endRefreshing()
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: CellIdentifier.reuseIdentifier)
        }
        cell!.selectionStyle = .None

        return cell!
    }

    // MARK: - TBEmptyDataSet data source
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString {
        let title = "暂无照片"
//        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(15.0), NSForegroundColorAttributeName: UIColor.redColor()];
        return NSAttributedString(string: title, attributes: nil)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString {
        let description = "你可以添加一些照片哦，让生活更精彩！"
//        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(12.0), NSForegroundColorAttributeName: UIColor.purpleColor()];
        return NSAttributedString(string: description, attributes: nil)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage {
        return UIImage(named: "icon-empty-photos")!
    }
    
    // MARK: - TBEmptyDataSet delegate
    func emptyDataSetScrollEnabled(scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetTapEnabled(scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetWillAppear(scrollView: UIScrollView!) {
         print("EmptyDataSet Will Appear!")
    }
    
    func emptyDataSetDidAppear(scrollView: UIScrollView!) {
        print("EmptyDataSet Did Appear!")
    }
    
    func emptyDataSetWillDisappear(scrollView: UIScrollView!) {
        print("EmptyDataSet Will Disappear!")
    }
    
    func emptyDataSetDidDisappear(scrollView: UIScrollView!) {
        print("EmptyDataSet Did Disappear!")
    }
    
    func emptyDataSetDidTapView(scrollView: UIScrollView!) {
        let alert = UIAlertController(title: nil, message: "Did Tap EmptyDataView!", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
}
