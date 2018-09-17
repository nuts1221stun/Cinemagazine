//
//  CNMLocationDataModel.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/16.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

struct CNMLocationDataModel: Decodable {
    var city: String?
    var countryCode: String?
    var countryName: String?
    var continentCode: String?
    var continentName: String?
    var ipAdress: String?
    enum CodingKeys : String, CodingKey {
        case city
        case countryCode = "country_code"
        case countryName = "country_name"
        case continentCode = "continent_code"
        case continentName = "continent_name"
        case ipAdress = "ip"
    }
}
