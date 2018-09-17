//
//  CNMImageView.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/15.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit
import SDWebImage

class CNMImageView: UIImageView {
    var aspectRatio: CGFloat = 1
    var imageUrl: String? {
        didSet {
            guard let imageUrlString = imageUrl,
                let imageUrl = URL(string: imageUrlString) else {
                return
            }
            sd_setImage(with: imageUrl, placeholderImage: nil, options: SDWebImageOptions.avoidAutoSetImage) { [weak self] (image, error, _, url) in
                guard let strongSelf = self,
                    error == nil,
                    url == imageUrl else {
                    return
                }
                strongSelf.image = image
            }
        }
    }
    override var image: UIImage? {
        didSet {
            imageUrl = nil
        }
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if aspectRatio == 0 {
            return .zero
        }
        var fittingSize = size
        fittingSize.height = fittingSize.width / aspectRatio
        return fittingSize
    }
}

extension CNMImageView {
    func populate(withData data: CNMImageViewModelProtocol?) {
        let width = bounds.width == 0 ? UIScreen.main.bounds.width : bounds.width
        imageUrl = data?.imageUrl(fittingWidth: width)
        aspectRatio = data?.aspectRatio ?? 0
    }
}
