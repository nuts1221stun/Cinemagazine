//
//  CNMCollectionItem.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/19.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation
import LayoutKit

protocol CNMCollectionItemProtocol: class {
    var layout: Layout? { get }
    var arrangement: LayoutArrangement? { get set }
    var numberOfItemsPerRow: Int { get }
}

class CNMCollectionItem: CNMCollectionItemProtocol {
    var numberOfItemsPerRow: Int
    var layout: Layout?
    var arrangement: LayoutArrangement?

    init(layout: Layout?,
         numberOfItemsPerRow: Int) {
        self.numberOfItemsPerRow = numberOfItemsPerRow
        self.layout = layout
    }
}
