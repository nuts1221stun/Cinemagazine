//
//  LabelLayout+TextViewModel.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/20.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit
import LayoutKit

extension LabelLayout {
    convenience init(text: CNMTextViewModelProtocol,
                     alignment: Alignment = LabelLayoutDefaults.defaultAlignment,
                     flexibility: Flexibility = LabelLayoutDefaults.defaultFlexibility,
                     viewReuseId: String? = nil,
                     config: ((Label) -> Void)? = nil) {
        let configBlock = { (label: Label) in
            label.textColor = text.textColor
            config?(label)
        }
        self.init(text: text.text ?? "",
                  font: text.font ?? UIFont.systemFont(ofSize: 17),
                  lineHeight: nil,
                  numberOfLines: text.numberOfLines ?? 0,
                  alignment: alignment,
                  flexibility: flexibility,
                  viewReuseId: viewReuseId,
                  config: configBlock)
    }
}
