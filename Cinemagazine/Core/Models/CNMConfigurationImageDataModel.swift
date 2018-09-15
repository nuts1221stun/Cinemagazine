//
//  CNMConfigurationImageDataModel.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/15.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

enum CNMImageType {
    case backdrop
    case logo
    case poster
    case profile
    case still
}

struct CNMConfigurationImageDataModel: Decodable {
    private var typeToImageSizeMap = [CNMImageType: CNMImageSizeDataModel]()
    private(set) var baseUrl: String?
    private(set) var backdropSizes: CNMImageSizeDataModel?
    private(set) var logoSizes: CNMImageSizeDataModel?
    private(set) var posterSizes: CNMImageSizeDataModel?
    private(set) var profileSizes: CNMImageSizeDataModel?
    private(set) var stillSizes: CNMImageSizeDataModel?
    enum CodingKeys : String, CodingKey {
        case baseUrl = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        baseUrl = try values.decode(String.self, forKey: .baseUrl)
        var sizes = try values.decodeIfPresent([String].self, forKey: .backdropSizes)
        backdropSizes = CNMImageSizeDataModel(sizes: sizes)
        sizes = try values.decodeIfPresent([String].self, forKey: .logoSizes)
        logoSizes = CNMImageSizeDataModel(sizes: sizes)
        sizes = try values.decodeIfPresent([String].self, forKey: .posterSizes)
        posterSizes = CNMImageSizeDataModel(sizes: sizes)
        sizes = try values.decodeIfPresent([String].self, forKey: .profileSizes)
        profileSizes = CNMImageSizeDataModel(sizes: sizes)
        sizes = try values.decodeIfPresent([String].self, forKey: .stillSizes)
        stillSizes = CNMImageSizeDataModel(sizes: sizes)

        if let backdropSizes = backdropSizes {
            typeToImageSizeMap[.backdrop] = backdropSizes
        }
        if let logoSizes = logoSizes {
            typeToImageSizeMap[.logo] = logoSizes
        }
        if let posterSizes = posterSizes {
            typeToImageSizeMap[.poster] = posterSizes
        }
        if let profileSizes = profileSizes {
            typeToImageSizeMap[.profile] = profileSizes
        }
        if let stillSizes = stillSizes {
            typeToImageSizeMap[.still] = stillSizes
        }
    }
    func imageSize(forType imageType: CNMImageType) -> CNMImageSizeDataModel? {
        return typeToImageSizeMap[imageType]
    }
}
