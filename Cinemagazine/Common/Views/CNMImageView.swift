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
}
