//
//  CNMMovieTitleCell.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/16.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

class CNMMovieTitleCell: CNMBaseCell {
    var label = CNMLabel()
    var button = UIButton(type: .system)
    private var buttonSize: CGSize = .zero

    private var title: CNMTextViewModel?
    private var buttonEventHandler: CNMButtonEventHandlerProtocol?
    override var data: Any? {
        didSet {
            title = data as? CNMTextViewModel
        }
    }
    override var eventHandler: AnyObject? {
        didSet {
            buttonEventHandler = eventHandler as? CNMButtonEventHandlerProtocol
        }
    }

    override func commonInit() {
        super.commonInit()
        contentView.addSubview(label)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.setTitle("Book Now", for: .normal)
        button.backgroundColor = UIColor.blue
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        buttonSize = button.sizeThatFits(CGSize(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        contentView.addSubview(button)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonFrame = CGRect(x: bounds.width - buttonSize.width,
                                 y: title?.insets?.top ?? 0,
                                 width: buttonSize.width,
                                 height: buttonSize.height)
        button.frame = buttonFrame
        let labelFrame = CGRect(x: 0,
                                y: 0,
                                width: buttonFrame.minX,
                                height: bounds.height)
        label.frame = labelFrame
    }
    static let preRenderingCell = CNMMovieTitleCell()
    override class func sizeThatFits(_ size: CGSize, data: Any?) -> CGSize {
        preRenderingCell.frame = CGRect(x: 0, y: 0, width: size.width, height: 100)
        preRenderingCell.populate(withData: data)
        let buttonSize = preRenderingCell.buttonSize
        let labelBoundingSize = CGSize(width: size.width - buttonSize.width, height: size.height)
        let labelSize = preRenderingCell.label.sizeThatFits(labelBoundingSize)
        let height = max(labelSize.height, buttonSize.height + (preRenderingCell.title?.insets?.top ?? 0))
        return CGSize(width: size.width, height: height)
    }
    override func populate(withData data: Any?) {
        super.populate(withData: data)
        label.populate(withData: title)
    }
    @objc func didTapButton() {
        buttonEventHandler?.didTapButton()
    }
}
