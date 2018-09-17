//
//  CNMPaginationDataModel.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/14.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

struct CNMPaginationDataModel: Decodable {
    private(set) var page: Int?
    private(set) var totalResults: Int?
    private(set) var totalPages: Int?
    private(set) var results: [CNMMovieDataModel]?

    enum CodingKeys : String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}
