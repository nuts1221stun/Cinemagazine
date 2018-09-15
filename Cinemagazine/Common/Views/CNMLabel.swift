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
    override func draw(_ rect: CGRect) {
        var newRect = bounds

        defer {
            super.drawText(in: newRect)
        }
        if textVerticalAlignment == .center {
            return
        }

        let fittingSize = (text as NSString?)?.boundingRect(with: bounds.size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: font], context: nil).size
        if var size = fittingSize {
            let height = numberOfLines > 0 ? font.lineHeight * CGFloat(numberOfLines) : CGFloat.greatestFiniteMagnitude
            size.height = min(height, size.height)
            newRect.size = size
            if textVerticalAlignment == .bottom {
                newRect.origin.y = rect.height - size.height
            }
        }
    }
}
