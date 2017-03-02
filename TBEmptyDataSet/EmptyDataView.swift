//
//  EmptyDataView.swift
//  TBEmptyDataSet
//
//  Created by Xin Hong on 15/11/19.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

internal class EmptyDataView: UIView {
    fileprivate struct ViewStrings {
        static let contentView = "contentView"
        static let imageView = "imageView"
        static let titleLabel = "titleLabel"
        static let descriptionLabel = "descriptionLabel"
        static let customView = "customView"
    }

    // MARK: - Properties
    internal lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor.clear
        contentView.alpha = 0
        return contentView
    }()

    internal lazy var imageView: UIImageView = { [unowned self] in
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFill
        self.contentView.addSubview(imageView)
        return imageView
    }()

    internal lazy var titleLabel: UILabel = { [unowned self] in
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.systemFont(ofSize: 27)
        titleLabel.textColor = UIColor(white: 0.6, alpha: 1)
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        self.contentView.addSubview(titleLabel)
        return titleLabel
    }()

    internal lazy var descriptionLabel: UILabel = { [unowned self] in
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.backgroundColor = UIColor.clear
        descriptionLabel.font = UIFont.systemFont(ofSize: 17)
        descriptionLabel.textColor = UIColor(white: 0.6, alpha: 1)
        descriptionLabel.textAlignment = .center
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        self.contentView.addSubview(descriptionLabel)
        return descriptionLabel
    }()

    internal var customView: UIView? {
        willSet {
            if let customView = customView {
                customView.removeFromSuperview()
            }
        }
        didSet {
            if let customView = customView {
                contentView.addSubview(customView)
            }
        }
    }
    internal var tapGesture: UITapGestureRecognizer?
    internal var verticalOffset = DefaultValues.verticalOffset
    internal var verticalSpaces = DefaultValues.verticalSpaces

    // MARK: - Helper
    fileprivate func shouldShowImageView() -> Bool {
        return imageView.image != nil
    }

    fileprivate func shouldShowTitleLabel() -> Bool {
        if let title = titleLabel.attributedText {
            return title.length > 0
        }
        return false
    }

    fileprivate func shouldShowDescriptionLabel() -> Bool {
        if let description = descriptionLabel.attributedText {
            return description.length > 0
        }
        return false
    }

    fileprivate func removeAllConstraints() {
        contentView.removeConstraints(contentView.constraints)
        removeConstraints(constraints)
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
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.contentView.alpha = 1
        })
    }

    // MARK: - Actions
    // swiftlint:disable function_body_length
    internal func setConstraints() {
        let centerX = NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: verticalOffset)
        addConstraint(centerX)
        addConstraint(centerY)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(ViewStrings.contentView)]|", options: [], metrics: nil, views: [ViewStrings.contentView: contentView]))

        if let customView = customView {
            let translatesFrameIntoConstraints = customView.translatesAutoresizingMaskIntoConstraints
            customView.translatesAutoresizingMaskIntoConstraints = false

            if translatesFrameIntoConstraints {
                contentView.addConstraint(NSLayoutConstraint(item: customView, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: customView.frame.width))
                contentView.addConstraint(NSLayoutConstraint(item: customView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: customView.frame.height))

                contentView.addConstraint(NSLayoutConstraint(item: customView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0))
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[\(ViewStrings.customView)]|", options: [], metrics: nil, views: [ViewStrings.customView: customView]))
            } else {
                contentView.addConstraint(NSLayoutConstraint(item: customView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0))
                contentView.addConstraint(NSLayoutConstraint(item: customView, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0))
                contentView.addConstraint(NSLayoutConstraint(item: customView, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0))

                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[\(ViewStrings.customView)]|", options: [], metrics: nil, views: [ViewStrings.customView: customView]))
            }
        } else {
            var viewStrings = [String]()
            var views = [String: UIView]()

            if shouldShowImageView() {
                if imageView.superview == nil {
                    contentView.addSubview(imageView)
                }
                let viewString = ViewStrings.imageView
                viewStrings.append(viewString)
                views[viewString] = imageView

                contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0))
            } else {
                imageView.removeFromSuperview()
            }

            if shouldShowTitleLabel() {
                if titleLabel.superview == nil {
                    contentView.addSubview(titleLabel)
                }
                let viewString = ViewStrings.titleLabel
                viewStrings.append(viewString)
                views[viewString] = titleLabel
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[\(ViewStrings.titleLabel)(>=0)]-|", options: [], metrics: nil, views: [ViewStrings.titleLabel: titleLabel]))
            } else {
                titleLabel.removeFromSuperview()
            }

            if shouldShowDescriptionLabel() {
                if descriptionLabel.superview == nil {
                    contentView.addSubview(descriptionLabel)
                }
                let viewString = ViewStrings.descriptionLabel
                viewStrings.append(viewString)
                views[viewString] = descriptionLabel
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[\(ViewStrings.descriptionLabel)(>=0)]-|", options: [], metrics: nil, views: [ViewStrings.descriptionLabel: descriptionLabel]))
            } else {
                descriptionLabel.removeFromSuperview()
            }

            var verticalFormat = String()
            for (index, viewString) in viewStrings.enumerated() {
                verticalFormat += "[\(viewString)]"
                if index != viewStrings.count - 1 {
                    let verticalSpace = index < verticalSpaces.count ? verticalSpaces[index] : DefaultValues.verticalSpace
                    verticalFormat += "-(\(verticalSpace))-"
                }
            }

            if !verticalFormat.isEmpty {
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|\(verticalFormat)|", options: [], metrics: nil, views: views))
            }
        }
    }

    internal func prepareForDisplay() {
        imageView.image = nil
        titleLabel.attributedText = nil
        descriptionLabel.attributedText = nil
        customView = nil
        removeAllConstraints()
    }

    internal func reset() {
        imageView.image = nil
        titleLabel.attributedText = nil
        descriptionLabel.attributedText = nil
        customView = nil
        tapGesture = nil
        removeAllConstraints()
    }
}
