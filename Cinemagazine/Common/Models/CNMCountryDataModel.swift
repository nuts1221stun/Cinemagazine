//
//  CNMCountryDataModel.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/14.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

struct CNMCountryDataModel: Decodable {
    private(set) var iso31661: String?
    private(set) var name: String?

    enum CodingKeys : String, CodingKey {
        case iso31661 = "iso_3166_1"
        case name
    }
}
