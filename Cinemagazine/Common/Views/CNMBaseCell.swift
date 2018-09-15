//
//  CNMBaseCell.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/14.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

class CNMBaseCell<Data>: UICollectionViewCell {
    var data: Data?
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
    func commonInit() {

    }
    class func sizeThatFits(_ size: CGSize, data: Data) -> CGSize {
        return .zero
    }
    func populate(withData data: Data) {
        self.data = data
    }
}
