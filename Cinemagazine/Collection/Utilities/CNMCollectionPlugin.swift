//
//  CNMCollectionPlugin.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/19.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

protocol CNMCollectionPluginProtocol {
    var identifier: String { get }
    var scrollViewDidScroll: ((_ scrollView: UIScrollView) -> Void)? { get }
}

class CNMCollectionPlugin: CNMCollectionPluginProtocol {
    var scrollViewDidScroll: ((UIScrollView) -> Void)?
    var identifier: String
    init(identifier: String) {
        self.identifier = identifier
    }
}
