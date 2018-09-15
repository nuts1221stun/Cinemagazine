//
//  CNMPosterCell.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/14.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

class CNMPosterCell: CNMBaseCell<CNMPosterViewModelProtocol> {
    private var imageView = UIImageView()
    private var titleLabel = CNMLabel()
    private var popularityLabel = CNMLabel()

    struct Constants {
        static let imageAspectRatio: CGFloat = 0.75
        static let imageToTitleSpacing: CGFloat = 4
        static let titleToPopularitySpacing: CGFloat = 4
        static let titleNumberOfLines: Int = 2
        static let popularityNumberOfLines: Int = 1
    }
    override func commonInit() {
        super.commonInit()
        contentView.addSubview(imageView)

        titleLabel.numberOfLines = Constants.titleNumberOfLines
        contentView.addSubview(titleLabel)

        popularityLabel.numberOfLines = Constants.popularityNumberOfLines
        contentView.addSubview(popularityLabel)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let aspectRatio = data?.image?.aspectRatio ?? 0
        let imageWidth = bounds.width
        let imageHeight = imageWidth / (aspectRatio > 0 ? aspectRatio : Constants.imageAspectRatio)
        imageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)

        let titleHeight = titleLabel.font.lineHeight * CGFloat(Constants.titleNumberOfLines)
        titleLabel.frame = CGRect(x: 0,
                                  y: imageView.frame.maxY + Constants.imageToTitleSpacing,
                                  width: imageWidth,
                                  height: titleHeight)

        let popularityHeight = popularityLabel.font.lineHeight * CGFloat(Constants.popularityNumberOfLines)
        popularityLabel.frame = CGRect(x: 0,
                                       y: titleLabel.frame.maxY + Constants.titleToPopularitySpacing,
                                       width: imageWidth,
                                       height: popularityHeight)
    }
    static let preRenderingCell = CNMPosterCell()
    override class func sizeThatFits(_ size: CGSize, data: CNMPosterViewModelProtocol) -> CGSize {
        preRenderingCell.frame = CGRect(x: 0, y: 0, width: size.width, height: 100)
        preRenderingCell.populate(withData: data)
        preRenderingCell.setNeedsLayout()
        preRenderingCell.layoutIfNeeded()
        return CGSize(width: size.width, height: preRenderingCell.popularityLabel.frame.maxY)
    }
    override func populate(withData data: CNMPosterViewModelProtocol) {
        super.populate(withData: data)
        imageView.backgroundColor = UIColor.lightGray
        titleLabel.populate(withData: data.title)
        popularityLabel.populate(withData: data.popularity)
    }
}
