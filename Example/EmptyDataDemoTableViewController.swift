//
//  EmptyDataDemoTableViewController.swift
//  TBEmptyDataSetExample
//
//  Created by 洪鑫 on 15/11/24.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit
import TBEmptyDataSet

class EmptyDataDemoTableViewController: UITableViewController, TBEmptyDataSetDataSource, TBEmptyDataSetDelegate {
    // MARK: - Structs
    private struct CellIdentifier {
        static let reuseIdentifier = "Cell"
    }

    // MARK: - Properties
    var indexPath = NSIndexPath()
    private var isLoading = false
    private var dataCount = 0

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "TableView"
        tableView.tableFooterView = UIView()
        refreshControl?.addTarget(self, action: "fetchData:", forControlEvents: .ValueChanged)

        tableView.emptyDataSetDataSource = self
        tableView.emptyDataSetDelegate = self

        if indexPath.row != 0 {
            loadData(self)
        }
    }

    // MARK: - Helper
    func fetchData(sender: AnyObject) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            self.dataCount = 7
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

    func loadData(sender: AnyObject) {
        isLoading = true
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.75 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            self.isLoading = false
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source and delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCount
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: CellIdentifier.reuseIdentifier)
        }
        cell!.textLabel?.text = "Cell"
        cell!.detailTextLabel?.text = "Click to delete"
        return cell!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.beginUpdates()
        dataCount--
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        tableView.endUpdates()
    }

    // MARK: - TBEmptyDataSet data source
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString? {
        let title = EmptyData.titles[indexPath.row]
        var attributes: [String : AnyObject]?
        if indexPath.row == 1 {
            attributes = [NSFontAttributeName: UIFont.systemFontOfSize(22.0), NSForegroundColorAttributeName: UIColor.grayColor()]
        } else if indexPath.row == 2 {
            attributes = [NSFontAttributeName: UIFont.systemFontOfSize(24.0), NSForegroundColorAttributeName: UIColor.grayColor()]
        }
        return NSAttributedString(string: title, attributes: attributes)
    }

    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString? {
        let description = EmptyData.descriptions[indexPath.row]
        var attributes: [String : AnyObject]?
        if indexPath.row == 1 {
            attributes = [NSFontAttributeName: UIFont.systemFontOfSize(17.0), NSForegroundColorAttributeName: UIColor(red: 3 / 255, green: 169 / 255, blue: 244 / 255, alpha: 1)]
        } else if indexPath.row == 2 {
            attributes = [NSFontAttributeName: UIFont.systemFontOfSize(18.0), NSForegroundColorAttributeName: UIColor.purpleColor()]
        }
        return NSAttributedString(string: description, attributes: attributes)
    }

    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage? {
        return EmptyData.images[indexPath.row]
    }

    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        if let navigationBar = navigationController?.navigationBar {
            return -navigationBar.frame.height * 0.75
        }
        return 0
    }

    func customViewForEmptyDataSet(scrollView: UIScrollView!) -> UIView? {
        if isLoading {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activityIndicator.startAnimating()
            return activityIndicator
        }
        return nil
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
