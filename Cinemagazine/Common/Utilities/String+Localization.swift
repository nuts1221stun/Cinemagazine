//
//  String+Localization.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/21.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

extension String {
    func cnm_localized(bundle: Bundle = .main) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: self, comment: "")
    }
}
