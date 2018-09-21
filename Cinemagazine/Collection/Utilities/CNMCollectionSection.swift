//
//  CNMCollectionSection.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/19.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

protocol CNMCollectionSectionProtocol: class {
    var identifier: String { get }
    var items: [CNMCollectionItem] { get }
    var insets: UIEdgeInsets { get }
    var horizontalSpacing: CGFloat { get }
    var verticalSpacing: CGFloat { get }
    var delegate: CNMCollectionSectionDelegate? { get set }
}

protocol CNMCollectionSectionDelegate: class {
    func collectionSection(sectionDidSetItems section: CNMCollectionSectionProtocol, completion: (() -> Void)?)
    func collectionSection(section: CNMCollectionSectionProtocol, didInsertItemsAtIndices indices: [Int], completion: (() -> Void)?)
    func collectionSection(section: CNMCollectionSectionProtocol, didRemoveItemsAtIndices indices: [Int], completion: (() -> Void)?)
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

    func update(items: [CNMCollectionItem]?, completion: (() -> Void)? = nil) {
        guard let items = items else { return }
        self.items = items
        delegate?.collectionSection(sectionDidSetItems: self, completion: completion)
    }

    func insert(items: [CNMCollectionItem]?, completion: (() -> Void)? = nil) {
        guard let items = items else { return }
        let currentNumberOfItems = self.items.count
        let indices = [Int](currentNumberOfItems..<(currentNumberOfItems + items.count))
        self.items.append(contentsOf: items)
        delegate?.collectionSection(section: self, didInsertItemsAtIndices: indices, completion: completion)
    }

    func remove(itemsAtIndices indexSet: IndexSet, completion: (() -> Void)? = nil) {
        var items = self.items
        let indices = indexSet.sorted()
        for (_, index) in indices.enumerated().reversed() {
            items.remove(at: index)
        }
        self.items = items
        delegate?.collectionSection(section: self, didRemoveItemsAtIndices: indices, completion: completion)
    }
}
