//
//  CNMImageViewModel.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/15.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

protocol CNMImageViewModelProtocol {
    var imageUrl: String? { get }
    var aspectRatio: CGFloat? { get }
}

struct CNMImageViewModel: CNMImageViewModelProtocol {
    var imageUrl: String?
    var aspectRatio: CGFloat?
}
