//
//  EmptyDataDemoCollectionViewController.swift
//  TBEmptyDataSetExample
//
//  Created by 洪鑫 on 15/11/24.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit
import TBEmptyDataSet

class EmptyDataDemoCollectionViewController: UICollectionViewController, TBEmptyDataSetDataSource, TBEmptyDataSetDelegate {
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

        navigationItem.title = "CollectionView"
        collectionView!.backgroundColor = UIColor.whiteColor()

        collectionView!.emptyDataSetDataSource = self
        collectionView!.emptyDataSetDelegate = self

        if indexPath.row != 0 {
            loadData(self)
        }
    }

    // MARK: - Helper
    func loadData(sender: AnyObject) {
        isLoading = true
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            self.dataCount = 4
            self.isLoading = false
            self.collectionView!.reloadData()
        }
    }

    // MARK: - Collection view data source
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier.reuseIdentifier, forIndexPath: indexPath)

        let maskLayer = CAShapeLayer()
        let maskRect = cell.bounds
        maskLayer.frame = maskRect
        let cornerRadii = CGSize(width: 5, height: 5)
        let maskPath = UIBezierPath(roundedRect: maskRect, byRoundingCorners: .AllCorners, cornerRadii: cornerRadii)
        maskLayer.path = maskPath.CGPath
        cell.layer.mask = maskLayer

        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.dataCount -= 1
        collectionView.performBatchUpdates({
            self.collectionView?.deleteItemsAtIndexPaths([indexPath])
            }) { (finished) in
                self.collectionView?.updateEmptyDataSetIfNeeded()
        }
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

    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor? {
        return UIColor(white: 0.95, alpha: 1)
    }

    func customViewForEmptyDataSet(scrollView: UIScrollView!) -> UIView? {
        let loadingView: UIView = {
            if indexPath.row == 2 {
                return ExampleCustomView(frame: CGRect.zero)
            }

            let loadingImageView = UIImageView(image: UIImage(named: "loading")!)
            let view = UIView(frame: loadingImageView.frame)
            view.addSubview(loadingImageView)

            let animation: CABasicAnimation = {
                let animation = CABasicAnimation(keyPath: "transform")
                animation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
                animation.toValue = NSValue(CATransform3D: CATransform3DMakeRotation(CGFloat(M_PI_2), 0, 0, 1))
                animation.duration = 0.3
                animation.cumulative = true
                animation.repeatCount = FLT_MAX
                return animation
            }()
            loadingImageView.layer.addAnimation(animation, forKey: "loading")

            return view
        }()

        if isLoading {
            return loadingView
        } else {
            return nil
        }
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

extension EmptyDataDemoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 150, height: 90)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(20, 20, 20, 20)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 20
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 20
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

        collectionViewLayout.invalidateLayout()
        coordinator.animateAlongsideTransition({ (context) -> Void in

        }) { (context) -> Void in

        }
    }
}

class ExampleCustomView: UIView {
    private lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.textColor = UIColor.whiteColor()
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        return contentLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = UIColor.lightGrayColor()
        layer.cornerRadius = 6

        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.startAnimating()
        contentLabel.text = "Loading... Please wait a moment...\n\n(This is a custom empty data view, which is using pure AutoLayout)"
        addSubview(activityIndicatorView)
        addSubview(contentLabel)

        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[activityIndicatorView]-20-[contentLabel]-15-|", options: [], metrics: nil, views: ["activityIndicatorView": activityIndicatorView, "contentLabel": contentLabel]))
        addConstraint(NSLayoutConstraint(item: activityIndicatorView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[contentLabel]-15-|", options: [], metrics: nil, views: ["contentLabel": contentLabel]))

        translatesAutoresizingMaskIntoConstraints = false
    }
}
