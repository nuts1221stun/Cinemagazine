//
//  CNMNavigationManager.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/15.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit
import SafariServices

protocol CNMRootViewControllerProtocol {
    func startLoading()
}

class CNMNavigationManager {
    static let rootViewController = CNMDiscoveryViewController()
    static let navigationController: UINavigationController = {
        return UINavigationController(rootViewController: rootViewController)
    }()
    static func showWebContent(withUrl url: String?) {
        guard let url = url, let webUrl = URL(string: url) else {
            return
        }
        let webVC = SFSafariViewController(url: webUrl)
        navigationController.present(webVC, animated: true, completion: nil)
    }
}
