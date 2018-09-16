//
//  CNMLocationService.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/16.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

class CNMLocationService {
    static func fetchLocationInfo(callback: @escaping (_ page: CNMLocationDataModel?, _ error: Error?) -> Void) {
        CNMNetworkService.requestLocation(
        path: "/check",
        method: .get,
        parameters: nil,
        body: nil,
        header: nil) { (res, err) in
            var location: CNMLocationDataModel?
            if err == nil, let data = res {
                location = try? JSONDecoder().decode(CNMLocationDataModel.self, from: data)
            }
            callback(location, err)
        }
    }
}
