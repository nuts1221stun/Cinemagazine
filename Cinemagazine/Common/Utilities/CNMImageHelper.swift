//
//  CNMImageHelper.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/15.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

struct CNMImageHelper {
    private var imageConfiguration: CNMConfigurationImageDataModel?
    init?(imageConfiguration: CNMConfigurationImageDataModel?) {
        guard let config = imageConfiguration else {
            return nil
        }
        self.imageConfiguration = config
    }
    func imageUrl(forType imageType: CNMImageType, path: String?, fittingWidth: CGFloat) -> String? {
        guard let path = path,
            let imageConfig = imageConfiguration,
            let baseUrl = imageConfig.baseUrl else {
            return nil
        }
        let imageSize = imageConfig.imageSize(forType: imageType)
        let sizePath = (imageSize?.size(fittingWidth: fittingWidth) ?? .original).rawValue
        return "\(baseUrl)\(sizePath)/\(path)"
    }
}
