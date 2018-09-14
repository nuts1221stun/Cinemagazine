//
//  CNMMovieBaseService.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/14.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

enum APIVersion: String {
    case v3 = "3"
    case v4 = "4"
}

class CNMMovieBaseService {
    static private func newBaseUrl() -> URL? {
        return URL(string: CNMConfigurationManager.serviceHost)
    }
    static func request(
        version: APIVersion,
        path: String,
        method: RequestMethod,
        parameters: [String: String]?,
        body: [String: Any]?,
        header: [String: String]?,
        callback: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        var requestParams: [String: String]? = parameters
        var requestHeader: [String: String]? = header
        switch version {
        case .v3:
            requestParams = requestParams ?? [String: String]()
            requestParams?.cnm_appendBaseRequestParameters()
        case .v4:
            requestHeader = requestHeader ?? [String: String]()
            requestHeader?.cnm_appendBaseRequestHeader()
        }
        let separator = path.hasPrefix("/") ? "" : "/"
        let requestPath = "/\(version.rawValue)\(separator)\(path)"
        let url = URL(string: requestPath, relativeTo: newBaseUrl())
        CNMNetworkService.request(url: url,
                                  method: method,
                                  parameters: requestParams,
                                  body: body,
                                  header: requestHeader,
                                  callback: callback)
    }
}

extension Dictionary where Key == String, Value == String {
    mutating func cnm_appendBaseRequestHeader() {
        self["Authorization"] = "Bearer \(CNMConfigurationManager.APIAccessToken)"
        self["Content-Type"] = "application/json;charset=utf-8"
    }
    mutating func cnm_appendBaseRequestParameters() {
        self["api_key"] = CNMConfigurationManager.APIKey
    }
}
