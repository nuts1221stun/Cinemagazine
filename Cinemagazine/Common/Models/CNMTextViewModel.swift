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
}

struct CNMTextViewModel: CNMTextViewModelProtocol {
    var text: String?
    var font: UIFont?
    var textColor: UIColor?
}

extension UILabel {
    func populate(withData data: CNMTextViewModelProtocol?) {
        text = data?.text
        font = data?.font
        textColor = data?.textColor
    }
}
