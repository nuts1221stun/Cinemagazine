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
    private var tapRecognizer: UITapGestureRecognizer?
    var isTapEnabled: Bool = false {
        didSet {
            tapRecognizer?.isEnabled = isTapEnabled
        }
    }
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
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapContent))
        contentView.addGestureRecognizer(recognizer)
        tapRecognizer = recognizer
        isTapEnabled = true
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
    @objc func didTapContent() {
    }
}
