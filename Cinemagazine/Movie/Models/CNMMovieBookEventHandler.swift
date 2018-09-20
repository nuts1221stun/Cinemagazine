//
//  CNMMovieBookEventHandler.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/16.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation
import SafariServices

class CNMMovieBookEventHandler: CNMButtonEventHandlerProtocol {
    func didTapButton() {
        CNMNavigationManager.showWebContent(withUrl: "https://www.cathaycineplexes.com.sg/")
    }
}
