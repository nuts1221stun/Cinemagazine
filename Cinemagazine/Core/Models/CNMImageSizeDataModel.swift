//
//  CNMImageSizeDataModel.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/15.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

enum CNMImageSize: String {
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
struct CNMImageSizeDataModel {
    let sizes: [CNMImageSize]
    var screenScale = UIScreen.main.scale
    private static let widthMap: [CNMImageSize: CGFloat] = [
        CNMImageSize.w45: 45,
        CNMImageSize.w92: 92,
        CNMImageSize.w154: 154,
        CNMImageSize.w185: 185,
        CNMImageSize.w300: 300,
        CNMImageSize.w342: 342,
        CNMImageSize.w500: 500,
        CNMImageSize.w780: 780,
        CNMImageSize.w1280: 1280,
        CNMImageSize.original: CGFloat.greatestFiniteMagnitude
    ]
    private static let heightMap: [CNMImageSize: CGFloat] = [
        CNMImageSize.h632: 632,
        CNMImageSize.original: CGFloat.greatestFiniteMagnitude
    ]
    init?(sizes: [String]?) {
        let sizeArray = sizes?.map { CNMImageSize(rawValue: $0) ?? .unknown }.filter { $0 != .unknown }
        guard let array = sizeArray else {
            return nil
        }
        self.sizes = array
    }
}

extension CNMImageSizeDataModel {
    func size(fittingWidth width: CGFloat) -> CNMImageSize {
        let actualWidth = width * screenScale
        var currentImageSize: CNMImageSize = .original
        var currentSizeValue = type(of: self).widthMap[currentImageSize] ?? .greatestFiniteMagnitude
        for (_, size) in sizes.enumerated().reversed() {
            let sizeValue = type(of: self).widthMap[size] ?? .greatestFiniteMagnitude
            if sizeValue < currentSizeValue {
                currentImageSize = size
                currentSizeValue = sizeValue
                if sizeValue < actualWidth {
                    break
                }
            }
        }
        return currentImageSize
    }
}
