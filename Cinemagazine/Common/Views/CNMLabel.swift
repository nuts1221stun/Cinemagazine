//
//  CNMLabel.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/15.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

class CNMLabel: UILabel {
    enum VerticalAlignment {
        case top
        case center
        case bottom
    }
    var textVerticalAlignment: VerticalAlignment = .top
    var insets: UIEdgeInsets = .zero
    override func draw(_ rect: CGRect) {
        var newRect = UIEdgeInsetsInsetRect(bounds, insets)

        defer {
            super.drawText(in: newRect)
        }
        if textVerticalAlignment == .center {
            return
        }
        var fittingSize = sizeThatFits(bounds.size)
        fittingSize.width -= (insets.left + insets.right)
        fittingSize.height -= (insets.top + insets.bottom)
        fittingSize.height = min(bounds.height, fittingSize.height)
        newRect.size = fittingSize
        if textVerticalAlignment == .bottom {
            newRect.origin.y = rect.height - fittingSize.height - insets.bottom
        }
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var boundingSize = size
        boundingSize.width -= (insets.left + insets.right)
        boundingSize.height -= (insets.top + insets.bottom)
        var fittingSize = (text as NSString?)?.boundingRect(with: boundingSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: font], context: nil).size ?? super.sizeThatFits(boundingSize)
        fittingSize.width += (insets.left + insets.right)
        fittingSize.height += (insets.top + insets.bottom)
        return fittingSize
    }
}
