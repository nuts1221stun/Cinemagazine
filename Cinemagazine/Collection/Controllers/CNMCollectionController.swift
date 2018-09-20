//
//  CNMCollectionController.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/18.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit
import LayoutKit

class CNMCollectionController: NSObject {
    struct Constants {
        static let cellType = UICollectionViewCell.self
        static let reuseIdentifier = "Cell"
    }
    private(set) var collectionView: UICollectionView
    private(set) var plugins = [CNMCollectionPluginProtocol]()
    private(set) var sections = [CNMCollectionSectionProtocol]()
    private(set) var sectionIdentifierSet = Set<String>()
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.register(Constants.cellType,
                                forCellWithReuseIdentifier: Constants.reuseIdentifier)
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    func add(plugin: CNMCollectionPluginProtocol) {
        plugins.append(plugin)
    }
    func remove(plugin: CNMCollectionPluginProtocol) {
        guard let index = plugins.index(where: { (targetPlugin) -> Bool in
            return targetPlugin.identifier == plugin.identifier
        }) else {
            return
        }
        plugins.remove(at: index)
    }
    func add(section: CNMCollectionSectionProtocol) {
        section.delegate = self
        sections.append(section)
    }
    func insert(section: CNMCollectionSectionProtocol, at index: Int) {
        section.delegate = self
        sections.insert(section, at: index)
    }
    func remove(sectionAt index: Int) {
        guard index < sections.count else {
            return
        }
        let section = sections[index]
        section.delegate = nil
        sections.remove(at: index)
    }
}

extension CNMCollectionController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for plugin in plugins {
            plugin.scrollViewDidScroll?(scrollView)
        }
    }
}

extension CNMCollectionController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section < sections.count else { return 0 }
        return sections[section].items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.section < sections.count,
            indexPath.item < sections[indexPath.section].items.count else {
            return UICollectionViewCell()
        }
        let cellItem = sections[indexPath.section].items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier, for: indexPath)
        cellItem.arrangement?.makeViews(in: cell.contentView, direction: .leftToRight)
        return cell
    }
}

extension CNMCollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath.section < sections.count,
            indexPath.item < sections[indexPath.section].items.count else {
            return .zero
        }
        let sectionItem = sections[indexPath.section]
        let cellItem = sectionItem.items[indexPath.item]
        var width = collectionView.bounds.width
        let sectionInsets = sectionItem.insets
        width -= (sectionItem.horizontalSpacing + sectionInsets.left + sectionInsets.right)
        width -= (collectionView.contentInset.left + collectionView.contentInset.right)
        width /= CGFloat(cellItem.numberOfItemsPerRow)
        let arrangement = cellItem.layout?.arrangement(origin: .zero, width: width, height: nil)
        cellItem.arrangement = arrangement
        return arrangement?.frame.size ?? .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard section < sections.count else {
            return .zero
        }
        let sectionItem = sections[section]
        return sectionItem.insets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard section < sections.count else {
            return 0
        }
        let sectionItem = sections[section]
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return sectionItem.verticalSpacing
        }
        return flowLayout.scrollDirection == .vertical ? sectionItem.verticalSpacing : sectionItem.horizontalSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard section < sections.count else {
            return 0
        }
        let sectionItem = sections[section]
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return sectionItem.horizontalSpacing
        }
        return flowLayout.scrollDirection == .vertical ? sectionItem.horizontalSpacing : sectionItem.verticalSpacing
    }
}

extension CNMCollectionController: CNMCollectionSectionDelegate {
    func collectionSection(sectionDidSetItems section: CNMCollectionSectionProtocol) {
        guard let sectionIndex = index(ofSection: section) else {
            return
        }
        collectionView.reloadSections(IndexSet(integer: sectionIndex))
    }
    func collectionSection(section: CNMCollectionSectionProtocol, didInsertItemsAtIndices indices: [Int]) {
        guard let sectionIndex = index(ofSection: section) else {
            return
        }
        let indexPaths = indices.map { (itemIndex) -> IndexPath in
            return IndexPath(item: itemIndex, section: sectionIndex)
        }
        collectionView.insertItems(at: indexPaths)
    }
    func collectionSection(section: CNMCollectionSectionProtocol, didRemoveItemsAtIndices indices: [Int]) {
        guard let sectionIndex = index(ofSection: section) else {
            return
        }
        let indexPaths = indices.map { (itemIndex) -> IndexPath in
            return IndexPath(item: itemIndex, section: sectionIndex)
        }
        collectionView.deleteItems(at: indexPaths)
    }
    func index(ofSection section: CNMCollectionSectionProtocol) -> Int? {
        return sections.index(where: { $0.identifier == section.identifier })
    }
}
