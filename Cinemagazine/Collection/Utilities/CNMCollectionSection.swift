//
//  CNMCollectionSection.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/19.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

protocol CNMCollectionSectionProtocol {
    var identifier: String { get }
    var items: [CNMCollectionItem] { get }
    var insets: UIEdgeInsets { get }
    var horizontalSpacing: CGFloat { get }
    var verticalSpacing: CGFloat { get }
    var delegate: CNMCollectionSectionDelegate? { get set }
}

protocol CNMCollectionSectionDelegate: class {
    func collectionSection(sectionDidSetItems section: CNMCollectionSectionProtocol)
    func collectionSection(section: CNMCollectionSectionProtocol, didInsertItemsAtIndices indices: [Int])
    func collectionSection(section: CNMCollectionSectionProtocol, didRemoveItemsAtIndices indices: [Int])
}

class CNMCollectionSection: CNMCollectionSectionProtocol {
    private(set) var identifier: String
    private(set) var items = [CNMCollectionItem]()
    var insets: UIEdgeInsets = .zero
    var horizontalSpacing: CGFloat = 0
    var verticalSpacing: CGFloat = 0
    weak var delegate: CNMCollectionSectionDelegate?

    init(identifier: String) {
        self.identifier = identifier
    }

    func update(items: [CNMCollectionItem]?) {
        guard let items = items else { return }
        self.items = items
        delegate?.collectionSection(sectionDidSetItems: self)
    }

    func insert(items: [CNMCollectionItem]?) {
        guard let items = items else { return }
        let currentNumberOfItems = self.items.count
        let indices = [Int](currentNumberOfItems..<(currentNumberOfItems + items.count))
        self.items.append(contentsOf: items)
        delegate?.collectionSection(section: self, didInsertItemsAtIndices: indices)
    }

    func remove(itemsAtIndices indexSet: IndexSet) {
        var items = self.items
        let indices = indexSet.sorted()
        for (_, index) in indices.enumerated().reversed() {
            items.remove(at: index)
        }
        self.items = items
        delegate?.collectionSection(section: self, didRemoveItemsAtIndices: indices)
    }
}
