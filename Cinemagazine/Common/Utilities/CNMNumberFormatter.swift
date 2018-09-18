//
//  CNMNumberFormatter.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/18.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

struct CNMNumberFormatter {
    static func popularityString(fromPopularity popularity: Double?) -> String? {
        guard let popularity = popularity else {
            return nil
        }
        return "🌟 \(popularity)"
    }
}
