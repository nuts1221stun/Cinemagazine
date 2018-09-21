//
//  CNMCollectionViewFlowLayout.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/21.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

class CNMCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attrs = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        var attributes = [UICollectionViewLayoutAttributes]()
        for attr in attrs {
            guard let attrCopy = attr.copy() as? UICollectionViewLayoutAttributes else {
                continue
            }
            attributes.append(attrCopy)
        }
        var centerYToAttributesMap = [Int: Set<UICollectionViewLayoutAttributes>]()
        var centerYToMinYMap = [Int: CGFloat]()
        for attr in attributes {
            let centerY = Int(ceil(attr.center.y))
            if centerYToAttributesMap[centerY] == nil {
                centerYToAttributesMap[centerY] = Set<UICollectionViewLayoutAttributes>()
            }
            centerYToAttributesMap[centerY]?.insert(attr)
            let minY = centerYToMinYMap[centerY] ?? CGFloat.greatestFiniteMagnitude
            if attr.frame.minY < minY {
                centerYToMinYMap[centerY] = attr.frame.minY
            }
        }
        for (centerY, attrSet) in centerYToAttributesMap {
            guard let minY = centerYToMinYMap[centerY] else {
                continue
            }
            for attr in attrSet {
                attr.frame.origin.y = minY
            }
        }
        return attributes
    }
}
