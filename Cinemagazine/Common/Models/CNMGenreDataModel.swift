//
//  CNMGenreDataModel.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/14.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

struct CNMGenreDataModel: Decodable {
    private(set) var id: Int?
    private(set) var name: String?

    enum CodingKeys : String, CodingKey {
        case id
        case name
    }
}
