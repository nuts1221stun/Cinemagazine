//
//  CNMMovieService.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/15.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

class CNMMovieService {
    static func fetchMovie(
        id: Int?,
        callback: @escaping (_ movie: CNMMovieDataModel?, _ error: Error?) -> Void) {
        guard let id = id else {
            callback(nil, nil)
            return
        }

        CNMNetworkService.requestTMDb(
            version: .v3,
            path: "movie/\(id)",
            method: .get,
            parameters: nil,
            body: nil,
            header: nil) { (res, err) in
                var movie: CNMMovieDataModel?
                if err == nil, let data = res {
                    movie = try? JSONDecoder().decode(CNMMovieDataModel.self, from: data)
                }
                callback(movie, err)
        }
    }
}
