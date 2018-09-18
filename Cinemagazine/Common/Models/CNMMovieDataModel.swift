//
//  CNMMovieDataModel.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/14.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

struct CNMMovieDataModel: Decodable {
    private(set) var adult: Bool?
    private(set) var backdropPath: String?
    private(set) var genres: [CNMGenreDataModel]?
    private(set) var homepage: String?
    private(set) var id: Int?
    private(set) var imdbId: String?
    private(set) var originalLanguage: String?
    private(set) var originalTitle: String?
    private(set) var overview: String?
    private(set) var popularity: Double?
    private(set) var posterPath: String?
    private(set) var productionCompanies: [CNMCompanyDataModel]?
    private(set) var productionCountries: [CNMCountryDataModel]?
    private(set) var releaseDate: String?
    private(set) var revenue: Int?
    private(set) var runtime: Int?
    private(set) var spokenLanguages: [CNMLanguageDataModel]?
    private(set) var status: String?
    private(set) var tagline: String?
    private(set) var title: String?
    private(set) var video: Bool?
    private(set) var voteAverage: Double?
    private(set) var voteCount: Int?

    enum CodingKeys : String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genres = "genres"
        case homepage
        case id
        case imdbId = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
