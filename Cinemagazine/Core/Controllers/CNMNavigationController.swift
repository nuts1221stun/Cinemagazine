//
//  CNMNavigationController.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/21.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

class CNMNavigationController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        topViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(pop))
        super.pushViewController(viewController, animated: true)
    }
    @objc private func pop() {
        popViewController(animated: true)
    }
}
