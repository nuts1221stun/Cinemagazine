//
//  CNMImageCell.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/15.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

class CNMImageCell: CNMBaseCell {
    private(set) var imageView = CNMImageView()

    override var data: Any? {
        didSet {
            image = data as? CNMImageViewModel
        }
    }
    private var image: CNMImageViewModel?

    override func commonInit() {
        super.commonInit()
        imageView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }

    static let preRenderingCell = CNMImageCell()
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    override class func sizeThatFits(_ size: CGSize, data: Any?) -> CGSize {
        preRenderingCell.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        preRenderingCell.populate(withData: data)
        let fittingSize = preRenderingCell.imageView.sizeThatFits(size)
        return fittingSize
    }
    override func populate(withData data: Any?) {
        super.populate(withData: data)
        imageView.populate(withData: image)
    }
}
