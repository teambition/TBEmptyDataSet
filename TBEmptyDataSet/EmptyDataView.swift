//
//  EmptyDataView.swift
//  TBEmptyDataSet
//
//  Created by Xin Hong on 15/11/19.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

class EmptyDataView: UIView {
    private struct ViewStrings {
        static let contentView = "contentView"
        static let imageView = "imageView"
        static let titleLabel = "titleLabel"
        static let descriptionLabel = "descriptionLabel"
        static let customView = "customView"
    }

    // MARK: - Properties
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor.clearColor()
        contentView.userInteractionEnabled = true
        contentView.alpha = 0
        return contentView
    }()

    lazy var imageView: UIImageView = { [unowned self] in
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clearColor()
        imageView.contentMode = .ScaleAspectFill
        imageView.userInteractionEnabled = false
        self.contentView.addSubview(imageView)
        return imageView
        }()

    lazy var titleLabel: UILabel = { [unowned self] in
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont.systemFontOfSize(27)
        titleLabel.textColor = UIColor(white: 0.6, alpha: 1)
        titleLabel.textAlignment = .Center
        titleLabel.lineBreakMode = .ByWordWrapping
        titleLabel.numberOfLines = 0
        self.contentView.addSubview(titleLabel)
        return titleLabel
        }()

    lazy var descriptionLabel: UILabel = { [unowned self] in
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.backgroundColor = UIColor.clearColor()
        descriptionLabel.font = UIFont.systemFontOfSize(17)
        descriptionLabel.textColor = UIColor(white: 0.6, alpha: 1)
        descriptionLabel.textAlignment = .Center
        descriptionLabel.lineBreakMode = .ByWordWrapping
        descriptionLabel.numberOfLines = 0
        self.contentView.addSubview(descriptionLabel)
        return descriptionLabel
        }()

    var tapGesture: UITapGestureRecognizer!
    var customView: UIView? {
        willSet {
            if let _ = customView {
                customView!.removeFromSuperview()
            }
        }
        didSet {
            if let _ = customView {
                customView!.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(customView!)
            }
        }
    }

    var verticalOffset: CGFloat!
    var verticalSpace: CGFloat!

    // MARK: - Helper
    private func removeAllConstraints() {
        contentView.removeConstraints(contentView.constraints)
        removeConstraints(constraints)
    }

    private func shouldShowImageView() -> Bool {
        return imageView.image != nil
    }

    private func shouldShowTitleLabel() -> Bool {
        return titleLabel.attributedText?.length > 0
    }

    private func shouldShowDescriptionLabel() -> Bool {
        return descriptionLabel.attributedText?.length > 0
    }

    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(self.contentView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func didMoveToSuperview() {
        frame = super.bounds
        UIView.animateWithDuration(0.25) { () -> Void in
            self.contentView.alpha = 1
        }
    }

    func resetEmptyDataView() {
        imageView.image = nil
        titleLabel.attributedText = nil
        descriptionLabel.attributedText = nil
        customView = nil

        removeAllConstraints()
    }

    // MARK: - Configuration
    func setConstraints() {
        let centerX = NSLayoutConstraint(item: contentView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: contentView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: verticalOffset)
        addConstraint(centerX)
        addConstraint(centerY)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[\(ViewStrings.contentView)]|", options: [], metrics: nil, views: [ViewStrings.contentView : contentView]))

        if let customView = customView {
            contentView.addConstraint(NSLayoutConstraint(item: customView, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1, constant: 0))
            contentView.addConstraint(NSLayoutConstraint(item: customView, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0))
            contentView.addConstraint(NSLayoutConstraint(item: customView, attribute: .Width, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: customView.frame.width))
            contentView.addConstraint(NSLayoutConstraint(item: customView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: customView.frame.height))
        } else {
            var viewStrings = [String]()
            var views = [String: UIView]()

            if shouldShowImageView() {
                let viewString = ViewStrings.imageView
                viewStrings.append(viewString)
                views[viewString] = imageView

                contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1, constant: 0))
            }

            if shouldShowTitleLabel() {
                let viewString = ViewStrings.titleLabel
                viewStrings.append(viewString)
                views[viewString] = titleLabel
                contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[\(ViewStrings.titleLabel)(>=0)]-|", options: [], metrics: nil, views: [ViewStrings.titleLabel : titleLabel]))
            } else {
                titleLabel.removeFromSuperview()
            }

            if shouldShowDescriptionLabel() {
                let viewString = ViewStrings.descriptionLabel
                viewStrings.append(viewString)
                views[viewString] = descriptionLabel
                contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[\(ViewStrings.descriptionLabel)(>=0)]-|", options: [], metrics: nil, views: [ViewStrings.descriptionLabel : descriptionLabel]))
            } else {
                descriptionLabel.removeFromSuperview()
            }

            var verticalFormat = String()
            for (index, viewString) in viewStrings.enumerate() {
                verticalFormat += "[\(viewString)]"
                if index != viewStrings.count - 1 {
                    verticalFormat += "-\(verticalSpace)-"
                }
            }

            if !verticalFormat.isEmpty {
                contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|\(verticalFormat)|", options: [], metrics: nil, views: views))
            }
        }
    }
}
