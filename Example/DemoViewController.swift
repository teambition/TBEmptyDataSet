//
//  DemoViewController.swift
//  TBEmptyDataSet
//
//  Created by 洪鑫 on 15/11/26.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

public struct EmptyData {
    static let images = [UIImage(named: "icon-empty-photos")!, UIImage(named: "icon-empty-events")!,UIImage(named: "icon-empty-message")!]
    static let titles = ["无照片", "无日程", "无新消息"]
    static let descriptions = ["你可以添加一些照片哦，让生活更精彩！", "暂时没有日程哦，添加一些日程吧！", "没有新消息哦，去找朋友聊聊天吧!"]
}

class DemoViewController: UITableViewController {
    // MARK: - Structs
    private struct Data {
        static let examples = ["Empty Photos", "Empty Events", "Empty Message"]
        static let sectionTitles = ["TableView", "CollectionView"]
    }

    private struct SegueIdentifier {
        static let showTableView = "ShowEmptyDataDemoTableView"
        static let showCollectionView = "ShowEmptyDataDemoCollectionView"
    }

    private struct CellIdentifier {
        static let reuseIdentifier = "Cell"
    }

    // MARK: - Properties
    var selectedIndexPath = NSIndexPath()

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "TBEmptyDataSet"
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationItem.backBarButtonItem = backButton
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source and delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Data.sectionTitles.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.examples.count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Data.sectionTitles[section]
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: CellIdentifier.reuseIdentifier)
        }
        cell!.accessoryType = .DisclosureIndicator
        cell!.textLabel!.text = Data.examples[indexPath.row]

        return cell!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        if indexPath.section == 0 {
            performSegueWithIdentifier(SegueIdentifier.showTableView, sender: self)
        } else if indexPath.section == 1 {
            performSegueWithIdentifier(SegueIdentifier.showCollectionView, sender: self)
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.showTableView {
            if let emptyDataDemoTableViewController = segue.destinationViewController as? EmptyDataDemoTableViewController {
                emptyDataDemoTableViewController.indexPath = selectedIndexPath
            }
        } else if segue.identifier == SegueIdentifier.showCollectionView {
            if let emptyDataDemoCollectionViewController = segue.destinationViewController as? EmptyDataDemoCollectionViewController {
                emptyDataDemoCollectionViewController.indexPath = selectedIndexPath
            }
        }
    }
}
