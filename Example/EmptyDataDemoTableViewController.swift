//
//  EmptyDataDemoTableViewController.swift
//  TBEmptyDataSetExample
//
//  Created by 洪鑫 on 15/11/24.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit
import TBEmptyDataSet

class EmptyDataDemoTableViewController: UITableViewController {
    // MARK: - Structs
    fileprivate struct CellIdentifier {
        static let reuseIdentifier = "Cell"
    }

    // MARK: - Properties
    var indexPath = IndexPath()
    fileprivate var isLoading = false
    fileprivate var dataCount = 0

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "TableView"
        tableView.tableFooterView = UIView()
        refreshControl?.addTarget(self, action: #selector(fetchData(_:)), for: .valueChanged)

        tableView.emptyDataSetDataSource = self
        tableView.emptyDataSetDelegate = self

        if indexPath.row != 0 {
            loadData(self)
        }
    }

    // MARK: - Helper
    @objc func fetchData(_ sender: Any) {
        let delayTime = DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            self.dataCount = 7
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

    func loadData(_ sender: Any) {
        isLoading = true
        let delayTime = DispatchTime.now() + Double(Int64(1.75 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            self.isLoading = false
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source and delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: CellIdentifier.reuseIdentifier)
        }
        cell!.textLabel?.text = "Cell"
        cell!.detailTextLabel?.text = "Click to delete"
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.beginUpdates()
        dataCount -= 1
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
}

extension EmptyDataDemoTableViewController: TBEmptyDataSetDataSource, TBEmptyDataSetDelegate {
    // MARK: - TBEmptyDataSet data source
    func imageForEmptyDataSet(in scrollView: UIScrollView) -> UIImage? {
        return EmptyData.images[indexPath.row]
    }

    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        let title = EmptyData.titles[indexPath.row]
        var attributes: [NSAttributedStringKey: Any]?
        if indexPath.row == 1 {
            attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 22.0),
                          NSAttributedStringKey.foregroundColor: UIColor.gray]
        } else if indexPath.row == 2 {
            attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 24.0),
                          NSAttributedStringKey.foregroundColor: UIColor.gray]
        }
        return NSAttributedString(string: title, attributes: attributes)
    }

    func descriptionForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        let description = EmptyData.descriptions[indexPath.row]
        var attributes: [NSAttributedStringKey: Any]?
        if indexPath.row == 1 {
            attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0),
                          NSAttributedStringKey.foregroundColor: UIColor(red: 3 / 255, green: 169 / 255, blue: 244 / 255, alpha: 1)]
        } else if indexPath.row == 2 {
            attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18.0),
                          NSAttributedStringKey.foregroundColor: UIColor.purple]
        }
        return NSAttributedString(string: description, attributes: attributes)
    }

    func verticalOffsetForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat {
        if let navigationBar = navigationController?.navigationBar {
            return -navigationBar.frame.height * 0.75
        }
        return 0
    }

    func verticalSpacesForEmptyDataSet(in scrollView: UIScrollView) -> [CGFloat] {
        return [25, 8]
    }

    func customViewForEmptyDataSet(in scrollView: UIScrollView) -> UIView? {
        if isLoading {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicator.startAnimating()
            return activityIndicator
        }
        return nil
    }

    // MARK: - TBEmptyDataSet delegate
    func emptyDataSetShouldDisplay(in scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetTapEnabled(in scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetScrollEnabled(in scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetDidTapEmptyView(in scrollView: UIScrollView) {
        let alert = UIAlertController(title: nil, message: "Did Tap EmptyDataView!", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    func emptyDataSetWillAppear(in scrollView: UIScrollView) {
        print("EmptyDataSet Will Appear!")
    }

    func emptyDataSetDidAppear(in scrollView: UIScrollView) {
        print("EmptyDataSet Did Appear!")
    }

    func emptyDataSetWillDisappear(in scrollView: UIScrollView) {
        print("EmptyDataSet Will Disappear!")
    }

    func emptyDataSetDidDisappear(in scrollView: UIScrollView) {
        print("EmptyDataSet Did Disappear!")
    }
}
