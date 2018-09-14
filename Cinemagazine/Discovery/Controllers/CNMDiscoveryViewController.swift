//
//  CNMDiscoveryViewController.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/13.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

class CNMDiscoveryViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        CNMDiscoveryService.fetchMovies { (data, error) in
            
        }
    }
}
