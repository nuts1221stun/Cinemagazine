//
//  CNMConfigurationManager.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/13.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

class CNMConfigurationManager {
    static let APIAccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyYjM2ZGY2ODUxZjU3ZWM3MjA4MjEyNWNkMTQyMjc5YiIsInN1YiI6IjViOTliNzZmYzNhMzY4MWQ3MDAwM2M0NCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.SncDKjKbinvBrUoG0fRZHklOI5G4GE2CQY9-gIWrVWI"
    static let APIKey = "2b36df6851f57ec72082125cd142279b"
    static let serviceHost = "https://api.themoviedb.org"

    static let shared = CNMConfigurationManager()
    private init() {}

    func setUp() {
        fetchLocalConfiguartions()
        fetchRemoteConfigurations()
    }

    private func fetchLocalConfiguartions() {
        guard let path = Bundle.main.path(forResource: "configuration", ofType: "json") else {
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let result = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            load(response: result)
        } catch {
            // handle error
        }
    }

    private func fetchRemoteConfigurations() {
        CNMMovieBaseService.request(version: .v3, path: "configuration", method: .get, parameters: nil, body: nil, header: nil) { [weak self] (res, err) in
            self?.load(response: res)
        }
    }

    private func load(response: Any?) {
        guard let json = response as? [String: Any] else {
            return
        }
        print("====================\(json)")
    }
}
