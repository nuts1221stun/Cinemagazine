//
//  CNMTimeFormatter.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/18.
//  Copyright © 2018 nuts. All rights reserved.
//

import Foundation

struct CNMTimeFormatter {
    static func durationString(fromTimeInMinutes minutes: Int?) -> String? {
        guard let minutes = minutes else {
            return nil
        }
        let hour = Int(minutes / 60)
        let minute = minutes % 60
        return  "\(hour):\(minute)"
    }
}
