//
//  CNMCollectionItem.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/19.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

protocol CNMCollectionItemProtocol {
    var cellType: CNMBaseCell.Type { get }
    var data: Any? { get }
    var eventHandler: AnyObject? { get }
    var numberOfItemsPerRow: Int { get }
}

struct CNMCollectionItem: CNMCollectionItemProtocol {
    var cellType: CNMBaseCell.Type
    var data: Any?
    var eventHandler: AnyObject?
    var numberOfItemsPerRow: Int
}
