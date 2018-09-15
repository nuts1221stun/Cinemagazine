//
//  CNMImageViewModel.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/15.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

protocol CNMImageViewModelProtocol {
    var imagePath: String? { get }
    var aspectRatio: CGFloat? { get }
}

extension CNMImageViewModelProtocol {
    func imageUrl(fittingWidth width: CGFloat) -> String? {
        return CNMImageHelper.imageUrl(forType: .poster, path: imagePath, fittingWidth: width)
    }
}

struct CNMImageViewModel: CNMImageViewModelProtocol {
    var imagePath: String?
    var aspectRatio: CGFloat?
}
