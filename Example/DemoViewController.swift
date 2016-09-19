//
//  DemoViewController.swift
//  TBEmptyDataSetExample
//
//  Created by 洪鑫 on 15/11/26.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

public struct EmptyData {
    static let images = [#imageLiteral(resourceName: "icon-empty-photos"), #imageLiteral(resourceName: "icon-empty-events"), #imageLiteral(resourceName: "icon-empty-message")]
    static let titles = ["无照片", "无日程", "无新消息"]
    static let descriptions = ["你可以添加一些照片哦，让生活更精彩！", "暂时没有日程哦，添加一些日程吧！", "没有新消息哦，去找朋友聊聊天吧!"]
}

class DemoViewController: UITableViewController {
    // MARK: - Structs
    fileprivate struct Data {
        static let examples = ["Empty Photos", "Empty Events", "Empty Message"]
        static let sectionTitles = ["TableView", "CollectionView"]
    }

    fileprivate struct SegueIdentifier {
        static let showTableView = "ShowEmptyDataDemoTableView"
        static let showCollectionView = "ShowEmptyDataDemoCollectionView"
    }

    fileprivate struct CellIdentifier {
        static let reuseIdentifier = "Cell"
    }

    // MARK: - Properties
    var selectedIndexPath = IndexPath()

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "EmptyDataSet Example"
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationItem.backBarButtonItem = backButton
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source and delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Data.sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.examples.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Data.sectionTitles[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: CellIdentifier.reuseIdentifier)
        }
        cell!.accessoryType = .disclosureIndicator
        cell!.textLabel!.text = Data.examples[indexPath.row]

        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        if indexPath.section == 0 {
            performSegue(withIdentifier: SegueIdentifier.showTableView, sender: self)
        } else if indexPath.section == 1 {
            performSegue(withIdentifier: SegueIdentifier.showCollectionView, sender: self)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.showTableView {
            if let emptyDataDemoTableViewController = segue.destination as? EmptyDataDemoTableViewController {
                emptyDataDemoTableViewController.indexPath = selectedIndexPath
            }
        } else if segue.identifier == SegueIdentifier.showCollectionView {
            if let emptyDataDemoCollectionViewController = segue.destination as? EmptyDataDemoCollectionViewController {
                emptyDataDemoCollectionViewController.indexPath = selectedIndexPath
            }
        }
    }
}
