//
//  CNMTextViewModel.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/15.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

protocol CNMTextViewModelProtocol {
    var text: String? { get }
    var font: UIFont? { get }
    var textColor: UIColor? { get }
    var numberOfLines: Int? { get }
//    var minNumberOfLines: Int? { get }
//    var insets: UIEdgeInsets? { get }
}

struct CNMTextViewModel: CNMTextViewModelProtocol {
    var text: String?
    var font: UIFont?
    var textColor: UIColor?
    var numberOfLines: Int?
//    var minNumberOfLines: Int?
//    var insets: UIEdgeInsets?
}

//extension CNMLabel {
//    func populate(withData data: CNMTextViewModelProtocol?) {
//        text = data?.text
//        font = data?.font
//        textColor = data?.textColor
//        numberOfLines = data?.numberOfLines ?? 0
//        insets = data?.insets ?? .zero
//    }
//}
