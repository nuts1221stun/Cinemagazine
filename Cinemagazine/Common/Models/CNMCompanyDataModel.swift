//
//  CNMCompanyDataModel.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/14.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

struct CNMCompanyDataModel: Decodable {
    private(set) var id: Int?
    private(set) var logoPath: String?
    private(set) var name: String?
    private(set) var originCountry: String?

    enum CodingKeys : String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}
