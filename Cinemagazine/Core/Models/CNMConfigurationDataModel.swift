//
//  CNMConfigurationDataModel.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/14.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

struct CNMConfigurationDataModel: Decodable {
    enum ImageSize: String {
        case w45
        case w92
        case w154
        case w185
        case w300
        case w342
        case w500
        case w780
        case w1280
        case h632
        case original
        case unknown
    }
    struct ImageSizes {
        private let sizes: [ImageSize]
        private static let widthMap: [ImageSize: Float] = [
            ImageSize.w45: 45,
            ImageSize.w92: 92,
            ImageSize.w154: 154,
            ImageSize.w185: 185,
            ImageSize.w300: 300,
            ImageSize.w342: 342,
            ImageSize.w500: 500,
            ImageSize.w780: 780,
            ImageSize.w1280: 1280,
            ImageSize.original: Float.greatestFiniteMagnitude
        ]
        private static let heightMap: [ImageSize: Float] = [
            ImageSize.h632: 632,
            ImageSize.original: Float.greatestFiniteMagnitude
        ]
        init?(sizes: [String]?) {
            let sizeArray = sizes?.map { ImageSize(rawValue: $0) ?? .unknown }.filter { $0 != .unknown }
            guard let array = sizeArray else {
                return nil
            }
            self.sizes = array
        }
        func size(fittingWidth width: Float) -> ImageSize {
            var currentImageSize: ImageSize = .original
            var currentSizeValue = type(of: self).widthMap[currentImageSize] ?? .greatestFiniteMagnitude
            for (_, size) in sizes.enumerated().reversed() {
                let sizeValue = type(of: self).widthMap[size] ?? .greatestFiniteMagnitude
                if sizeValue < currentSizeValue {
                    currentImageSize = size
                    currentSizeValue = sizeValue
                    if sizeValue < width {
                        break
                    }
                }
            }
            return currentImageSize
        }
    }
    private(set) var baseUrl: String?
    private(set) var backdropSizes: ImageSizes?
    private(set) var logoSizes: ImageSizes?
    private(set) var posterSizes: ImageSizes?
    private(set) var profileSizes: ImageSizes?
    private(set) var stillSizes: ImageSizes?
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
        backdropSizes = ImageSizes(sizes: sizes)
        sizes = try values.decodeIfPresent([String].self, forKey: .logoSizes)
        logoSizes = ImageSizes(sizes: sizes)
        sizes = try values.decodeIfPresent([String].self, forKey: .posterSizes)
        posterSizes = ImageSizes(sizes: sizes)
        sizes = try values.decodeIfPresent([String].self, forKey: .profileSizes)
        profileSizes = ImageSizes(sizes: sizes)
        sizes = try values.decodeIfPresent([String].self, forKey: .stillSizes)
        stillSizes = ImageSizes(sizes: sizes)
    }
}
