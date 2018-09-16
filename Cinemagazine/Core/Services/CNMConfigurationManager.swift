//
//  CNMConfigurationManager.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/13.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

class CNMConfigurationManager {
    static let movieAPIAccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyYjM2ZGY2ODUxZjU3ZWM3MjA4MjEyNWNkMTQyMjc5YiIsInN1YiI6IjViOTliNzZmYzNhMzY4MWQ3MDAwM2M0NCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.SncDKjKbinvBrUoG0fRZHklOI5G4GE2CQY9-gIWrVWI"
    static let movieAPIKey = "2b36df6851f57ec72082125cd142279b"
    static let movieServiceHost = "https://api.themoviedb.org"
    static private(set) var region = "TW"
    static private(set) var language = "zh-TW"

    static let shared = CNMConfigurationManager()
    private init() {}

    private(set) var configuration: CNMConfigurationDataModel?

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
            load(data: data)
        } catch {
            // handle error
        }
    }

    private func fetchRemoteConfigurations() {
        CNMNetworkService.requestMovie(version: .v3, path: "configuration", method: .get, parameters: nil, body: nil, header: nil) { [weak self] (data, err) in
            self?.load(data: data)
        }
    }

    private func load(data: Data?) {
        guard let data = data,
            let configuration = try? JSONDecoder().decode(CNMConfigurationDataModel.self, from: data) else {
            return
        }
        self.configuration = configuration
    }
}
