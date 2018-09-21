//
//  CNMLanguageDataModel.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/14.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

struct CNMLanguageDataModel: Decodable {
    private(set) var iso6391: String?
    private(set) var name: String?

    enum CodingKeys : String, CodingKey {
        case iso6391 = "iso_639_1"
        case name
    }
}
