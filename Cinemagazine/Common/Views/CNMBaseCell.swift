//
//  CNMBaseCell.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/14.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

class CNMBaseCell: UICollectionViewCell {
    var data: Any?
    var eventHandler: AnyObject?
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
    class func sizeThatFits(_ size: CGSize, data: Any) -> CGSize {
        return .zero
    }
    func populate(withData data: Any) {
        self.data = data
    }
    func populate(withEventHandler eventHandler: AnyObject) {
        self.eventHandler = eventHandler
    }
}
