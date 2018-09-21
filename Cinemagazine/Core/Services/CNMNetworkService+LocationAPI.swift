//
//  CNMNetworkService+LocationAPI.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/16.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

extension CNMNetworkService {
    static private func newLocationBaseUrl() -> URL? {
        return URL(string: CNMConfigurationManager.locationServiceHost)
    }
    static func requestLocation(
        path: String,
        method: RequestMethod,
        parameters: [String: String]?,
        body: [String: Any]?,
        header: [String: String]?,
        callback: @escaping (_ response: Data?, _ error: Error?) -> Void) {
        var requestParams = parameters ?? [String: String]()
        requestParams.cnm_appendLocationBaseRequestParameters()
        let url = URL(string: path, relativeTo: newLocationBaseUrl())
        CNMNetworkService.request(url: url,
                                  method: method,
                                  parameters: requestParams,
                                  body: body,
                                  header: header,
                                  callback: callback)
    }
}

extension Dictionary where Key == String, Value == String {
    mutating func cnm_appendLocationBaseRequestParameters() {
        self["access_key"] = CNMConfigurationManager.locationAPIKey
    }
}
