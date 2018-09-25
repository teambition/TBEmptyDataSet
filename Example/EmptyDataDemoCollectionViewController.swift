//
//  EmptyDataDemoCollectionViewController.swift
//  TBEmptyDataSetExample
//
//  Created by 洪鑫 on 15/11/24.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit
import TBEmptyDataSet

class EmptyDataDemoCollectionViewController: UICollectionViewController {
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

        navigationItem.title = "CollectionView"
        collectionView?.backgroundColor = .white

        collectionView?.emptyDataSetDataSource = self
        collectionView?.emptyDataSetDelegate = self

        if indexPath.row != 0 {
            loadData(self)
        }
    }

    // MARK: - Helper
    func loadData(_ sender: Any) {
        isLoading = true
        let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            self.dataCount = 4
            self.isLoading = false
            self.collectionView?.reloadData()
        }
    }

    // MARK: - Collection view data source
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.reuseIdentifier, for: indexPath)

        let maskLayer = CAShapeLayer()
        let maskRect = cell.bounds
        maskLayer.frame = maskRect
        let cornerRadii = CGSize(width: 5, height: 5)
        let maskPath = UIBezierPath(roundedRect: maskRect, byRoundingCorners: .allCorners, cornerRadii: cornerRadii)
        maskLayer.path = maskPath.cgPath
        cell.layer.mask = maskLayer

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dataCount -= 1
        collectionView.performBatchUpdates({
            self.collectionView?.deleteItems(at: [indexPath])
            }) { (_) in

        }
    }
}

extension EmptyDataDemoCollectionViewController: TBEmptyDataSetDataSource, TBEmptyDataSetDelegate {
    // MARK: - TBEmptyDataSet data source
    func imageForEmptyDataSet(in scrollView: UIScrollView) -> UIImage? {
        return EmptyData.images[indexPath.row]
    }

    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        let title = EmptyData.titles[indexPath.row]
        var attributes: [NSAttributedString.Key: Any]?
        if indexPath.row == 1 {
            attributes = [.font: UIFont.systemFont(ofSize: 22),
                          .foregroundColor: UIColor.gray]
        } else if indexPath.row == 2 {
            attributes = [.font: UIFont.systemFont(ofSize: 24),
                          .foregroundColor: UIColor.gray]
        }
        return NSAttributedString(string: title, attributes: attributes)
    }

    func descriptionForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        let description = EmptyData.descriptions[indexPath.row]
        var attributes: [NSAttributedString.Key: Any]?
        if indexPath.row == 1 {
            attributes = [.font: UIFont.systemFont(ofSize: 17),
                          .foregroundColor: UIColor(red: 3 / 255, green: 169 / 255, blue: 244 / 255, alpha: 1)]
        } else if indexPath.row == 2 {
            attributes = [.font: UIFont.systemFont(ofSize: 18),
                          .foregroundColor: UIColor.purple]
        }
        return NSAttributedString(string: description, attributes: attributes)
    }

    func backgroundColorForEmptyDataSet(in scrollView: UIScrollView) -> UIColor? {
        return UIColor(white: 0.95, alpha: 1)
    }

    func verticalOffsetForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat {
        if let navigationBar = navigationController?.navigationBar {
            return -navigationBar.frame.height * 0.75
        }
        return 0
    }

    func customViewForEmptyDataSet(in scrollView: UIScrollView) -> UIView? {
        let loadingView: UIView = {
            if indexPath.row == 2 {
                return ExampleCustomView(frame: CGRect.zero)
            }

            let loadingImageView = UIImageView(image: #imageLiteral(resourceName: "loading"))
            let view = UIView(frame: loadingImageView.frame)
            view.addSubview(loadingImageView)

            let animation: CABasicAnimation = {
                let animation = CABasicAnimation(keyPath: "transform")
                animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
                animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(.pi / 2, 0, 0, 1))
                animation.duration = 0.3
                animation.isCumulative = true
                animation.repeatCount = .greatestFiniteMagnitude
                return animation
            }()
            loadingImageView.layer.add(animation, forKey: "loading")

            return view
        }()

        if isLoading {
            return loadingView
        } else {
            return nil
        }
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

extension EmptyDataDemoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 90)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        collectionViewLayout.invalidateLayout()
        coordinator.animate(alongsideTransition: { (_) -> Void in

            }) { (_) -> Void in

        }
    }
}

class ExampleCustomView: UIView {
    fileprivate lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .white
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

    fileprivate func commonInit() {
        backgroundColor = .lightGray
        layer.cornerRadius = 6

        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.startAnimating()
        contentLabel.text = "Loading... Please wait a moment...\n\n(This is a custom empty data view, which is using pure AutoLayout)"
        addSubview(activityIndicatorView)
        addSubview(contentLabel)

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[activityIndicatorView]-20-[contentLabel]-15-|", options: [], metrics: nil, views: ["activityIndicatorView": activityIndicatorView, "contentLabel": contentLabel]))
        addConstraint(NSLayoutConstraint(item: activityIndicatorView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[contentLabel]-15-|", options: [], metrics: nil, views: ["contentLabel": contentLabel]))

        translatesAutoresizingMaskIntoConstraints = false
    }
}
