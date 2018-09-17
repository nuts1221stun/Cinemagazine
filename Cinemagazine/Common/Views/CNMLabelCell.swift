//
//  CNMLabelCell.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/15.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

class CNMLabelCell: CNMBaseCell {
    private(set) var label = CNMLabel()

    override var data: Any? {
        didSet {
            text = data as? CNMTextViewModel
        }
    }
    private var text: CNMTextViewModel?

    override func commonInit() {
        super.commonInit()
        contentView.addSubview(label)
    }

    static let preRenderingCell = CNMLabelCell()
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    override class func sizeThatFits(_ size: CGSize, data: Any) -> CGSize {
        preRenderingCell.populate(withData: data)
        var fittingSize = preRenderingCell.label.sizeThatFits(size)
        fittingSize.width = size.width
        return fittingSize
    }
    override func populate(withData data: Any) {
        super.populate(withData: data)
        label.populate(withData: text)
    }
}
