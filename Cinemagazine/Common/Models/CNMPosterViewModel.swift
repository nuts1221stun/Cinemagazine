//
//  CNMPosterViewModel.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/15.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

protocol CNMPosterViewModelProtocol {
    var image: CNMImageViewModelProtocol? { get }
    var title: CNMTextViewModelProtocol? { get }
    var popularity: CNMTextViewModelProtocol? { get }
}

struct CNMPosterViewModel: CNMPosterViewModelProtocol {
    var image: CNMImageViewModelProtocol?
    var title: CNMTextViewModelProtocol?
    var popularity: CNMTextViewModelProtocol?
}
