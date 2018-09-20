//
//  CNMAspectRatioLayout+ImageViewModel.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/21.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation
import LayoutKit

extension CNMAspectRatioLayout where V == CNMImageView {
    convenience init(image: CNMImageViewModelProtocol,
                     alignment: Alignment = LabelLayoutDefaults.defaultAlignment,
                     flexibility: Flexibility = LabelLayoutDefaults.defaultFlexibility,
                     viewReuseId: String? = nil,
                     config: ((V) -> Void)? = nil) {
        let configBlock = { (v: V) in
            v.populate(withData: image)
            config?(v)
        }
        self.init(aspectRatio: image.aspectRatio ?? 1,
                  alignment: alignment,
                  flexibility: flexibility,
                  viewReuseId: viewReuseId,
                  sublayout: nil,
                  config: configBlock)
    }
}
