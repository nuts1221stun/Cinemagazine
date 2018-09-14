//
//  CNMDiscoveryService.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/14.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

class CNMDiscoveryService {
    enum SortBy: String {
        case popularity
        case releaseDate = "release_date"
    }
    enum Order: String {
        case desc = "desc"
        case asc = "asc"
    }
    private enum DateLimit: String {
        case before = "lte"
        case after = "gte"
    }
    private struct Constants {
        static let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter
        } ()
        static let dateKey = "primary_release_date"
        static let sortKey = "sort_by"
        static let pageKey = "page"
    }
    static func fetchMovies(
        sortBy: SortBy = .releaseDate,
        order: Order = .desc,
        page: Int = 1,
        callback: @escaping (_ page: CNMPaginationDataModel?, _ error: Error?) -> Void) {

        let dateFormatter = Constants.dateFormatter
        let week: TimeInterval = 60 * 60 * 24 * 7
        var startDate = Date()
        startDate.addTimeInterval(-week)
        var endDate = Date()
        endDate.addTimeInterval(week)
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)

        let parameters: [String: String] = [
            Constants.sortKey: "\(sortBy.rawValue).\(order.rawValue)",
            "\(Constants.dateKey).\(DateLimit.before.rawValue)": endDateString,
            "\(Constants.dateKey).\(DateLimit.after.rawValue)": startDateString,
            Constants.pageKey: "\(page)"
        ]

        CNMNetworkService.requestTMDb(
        version: .v4,
        path: "discover/movie",
        method: .get,
        parameters: parameters,
        body: nil,
        header: nil) { (res, err) in
            var page: CNMPaginationDataModel?
            if err == nil, let data = res {
                page = try? JSONDecoder().decode(CNMPaginationDataModel.self, from: data)
            }
            callback(page, err)
        }
    }
}
