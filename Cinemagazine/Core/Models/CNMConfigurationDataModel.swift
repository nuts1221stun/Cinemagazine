//
//  CNMConfigurationDataModel.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/14.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

struct CNMConfigurationDataModel: Decodable {
    var image: CNMConfigurationImageDataModel?
    enum CodingKeys : String, CodingKey {
        case image = "images"
    }
}
