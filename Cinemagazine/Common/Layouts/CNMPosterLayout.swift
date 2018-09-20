//
//  CNMPosterLayout.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/19.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation
import LayoutKit

class CNMView: UIView {
    var tapRecognizer: UITapGestureRecognizer? {
        didSet {
            guard oldValue != tapRecognizer else {
                return
            }
            if let recognizer = oldValue,
                let index = gestureRecognizers?.index(of: recognizer) {
                gestureRecognizers?.remove(at: index)
            }
            if let recognizer = tapRecognizer {
                addGestureRecognizer(recognizer)
            }
        }
    }
}

class CNMPosterLayout: StackLayout<CNMView> {
    private let eventHandler: CNMPosterEventHandlerProtocol?
    init?(poster: CNMPosterViewModelProtocol?, eventHandler: CNMPosterEventHandlerProtocol? = nil) {
        guard let poster = poster else {
            return nil
        }
        let titleConfig = { (label: UILabel) in
            label.textColor = poster.title?.textColor
        }
        let titleLayout = LabelLayout<UILabel>(text: poster.title?.text ?? "",
                                               font: poster.title?.font ?? UIFont.systemFont(ofSize: 14),
                                               numberOfLines: 2,
                                               alignment: Alignment.topFill,
                                               config: titleConfig)
        let popularityConfig = { (label: UILabel) in
            label.textColor = poster.popularity?.textColor
        }
        let popularityLayout = LabelLayout<UILabel>(text: poster.popularity?.text ?? "",
                                                    font: poster.popularity?.font ?? UIFont.systemFont(ofSize: 12),
                                                    numberOfLines: 1,
                                                    alignment: Alignment.topFill,
                                                    config: popularityConfig)
//        let imageConfig = { (imageView: CNMImageView) in
//            imageView.populate(withData: poster.image)
//        }
//        let aspectRatio = poster.image?.aspectRatio ?? 1
        let image = poster.image ?? CNMImageViewModel(imagePath: nil,
                                                      aspectRatio: 0.666,
                                                      imageHelper: CNMImageHelper(imageConfiguration: CNMConfigurationManager.shared.configuration?.image))
        let imageLayout = CNMAspectRatioLayout<CNMImageView>(image: image,
                                                             alignment: Alignment.topFill)

//            CNMAspectRatioLayout<CNMImageView>(aspectRatio: aspectRatio,
//                                                             alignment: Alignment.topFill,
//                                                             config: imageConfig)
        let sublayouts: [Layout] = [
            imageLayout,
            titleLayout,
            popularityLayout
        ]
        self.eventHandler = eventHandler
        let tapRecognizer = UITapGestureRecognizer(target: eventHandler, action: #selector(eventHandler?.didTapPoster))
        let config = { (view: CNMView) in
            view.tapRecognizer = tapRecognizer
        }
        super.init(axis: .vertical,
                   spacing: 6,
                   sublayouts: sublayouts,
                   config: config)
    }
}
