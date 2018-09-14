//
//  CNMNetworkService.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/13.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation
import Alamofire

enum RequestMethod {
    case get
    case post
    case put
    case delete
}

class CNMNetworkService {
    private static let methodMap: [RequestMethod: HTTPMethod] = [
        RequestMethod.get: HTTPMethod.get,
        RequestMethod.post: HTTPMethod.post,
        RequestMethod.put: HTTPMethod.put,
        RequestMethod.delete: HTTPMethod.delete
    ]
    static func request(
        url: URL?,
        method: RequestMethod,
        parameters: [String: String]?,
        body: [String: Any]?,
        header: [String: String]?,
        callback: @escaping (_ response: Data?, _ error: Error?) -> Void) {
        guard let inputUrl = url,
            var urlComponents = URLComponents(url: inputUrl, resolvingAgainstBaseURL: true) else {
            callback(nil, nil)
            return
        }
        let requestMethod: HTTPMethod = methodMap[method] ?? .get

        if let params = parameters {
            var queryItems = [URLQueryItem]()
            for (key, val) in params {
                let queryItem = URLQueryItem(name: key, value: val)
                queryItems.append(queryItem)
            }
            urlComponents.queryItems = queryItems
        }

        guard let requestUrl = urlComponents.url else {
            callback(nil, nil)
            return
        }
        Alamofire.request(
            requestUrl,
            method: requestMethod,
            parameters: body,
            encoding: JSONEncoding.default,
            headers: header)
            .validate()
            .responseJSON { (res) in
                var error: Error?
                switch (res.result) {
                case .success(_):
                    break
                case .failure(let err):
                    error = err
                }
                callback(res.data, error)
        }
    }
}
