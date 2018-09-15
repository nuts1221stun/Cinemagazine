//
//  CNMImageHelper.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/15.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

struct CNMImageHelper {
    static func imageUrl(forType imageType: CNMImageType, path: String?, fittingWidth: CGFloat) -> String? {
        guard let path = path,
            let imageConfig = CNMConfigurationManager.shared.configuration?.image,
            let baseUrl = imageConfig.baseUrl else {
            return nil
        }
        let imageSize = imageConfig.imageSize(forType: imageType)
        let sizePath = (imageSize?.size(fittingWidth: fittingWidth) ?? .original).rawValue
        return "\(baseUrl)\(sizePath)/\(path)"
    }
}
