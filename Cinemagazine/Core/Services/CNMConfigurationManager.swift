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
    static let locationAPIKey = "dea7db4ec9fee41f0b9387e070456183"
    static let locationServiceHost = "http://api.ipstack.com" // https only for paid plans, use http temporarily
    var region: String {
        return location?.countryCode ?? "TW"
    }
    private(set) var language = "zh-TW"

    static let shared = CNMConfigurationManager()
    private init() {}

    private(set) var location: CNMLocationDataModel?
    private(set) var configuration: CNMConfigurationDataModel?

    func setUp(completion: @escaping () -> Void) {
        fetchLocationInfo(completion: completion)
        fetchLocalConfiguartions()
        fetchRemoteConfigurations()
    }

    private func fetchLocationInfo(completion: @escaping () -> Void) {
        CNMLocationService.fetchLocationInfo { [weak self] (location, err) in
            self?.location = location
            completion()
        }
    }

    private func fetchLocalConfiguartions() {
        if let language = NSLocale.preferredLanguages.first {
            let separator: Character = "-"
            var components = language.split(separator: separator)
            // remove script designator
            if components.count == 3 {
                components.remove(at: 1)
            }
            self.language = components.joined(separator: String(separator))
        }
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
