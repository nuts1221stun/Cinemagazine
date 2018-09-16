//
//  CNMNetworkService+TMDbAPI.swift
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

extension CNMNetworkService {
    static private func newBaseUrl() -> URL? {
        return URL(string: CNMConfigurationManager.serviceHost)
    }
    static func requestTMDb(
        version: APIVersion,
        path: String,
        method: RequestMethod,
        parameters: [String: String]?,
        body: [String: Any]?,
        header: [String: String]?,
        callback: @escaping (_ response: Data?, _ error: Error?) -> Void) {
        var requestParams = parameters ?? [String: String]()
        var requestHeader = header ?? [String: String]()
        requestParams.cnm_appendBaseRequestParameters(forVersion: version)
        requestHeader.cnm_appendBaseRequestHeader(forVersion: version)
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
    mutating func cnm_appendBaseRequestHeader(forVersion version: APIVersion) {
        if version == .v4 {
            self["Authorization"] = "Bearer \(CNMConfigurationManager.APIAccessToken)"
        }
        self["Content-Type"] = "application/json;charset=utf-8"
    }
    mutating func cnm_appendBaseRequestParameters(forVersion version: APIVersion) {
        if version == .v3 {
            self["api_key"] = CNMConfigurationManager.APIKey
        }
        self["region"] = CNMConfigurationManager.region
        self["language"] = CNMConfigurationManager.language
    }
}
