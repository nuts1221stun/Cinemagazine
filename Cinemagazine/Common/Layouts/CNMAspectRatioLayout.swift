//
//  CNMAspectRatioLayout.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/20.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit
import LayoutKit


// This class is based on https://github.com/linkedin/LayoutKit/issues/96#issuecomment-277423876
class CNMAspectRatioLayout<V: View>: BaseLayout<V>, ConfigurableLayout {
    let aspectRatio: CGFloat
    let sublayout: Layout?

    public init(aspectRatio: CGFloat,
                alignment: Alignment? = nil,
                flexibility: Flexibility = .flexible,
                viewReuseId: String? = nil,
                sublayout: Layout? = nil,
                config: ((V) -> Void)? = nil)
    {
        self.aspectRatio = aspectRatio
        self.sublayout = sublayout
        let alignment = alignment ?? Alignment(vertical: .top, horizontal: .fill)
        super.init(alignment: alignment, flexibility: flexibility, viewReuseId: viewReuseId, config: config)
    }

    // MARK: - Layout protocol
    func measurement(within maxSize: CGSize) -> LayoutMeasurement {
        let boundingRatio = maxSize.height > 0 ? maxSize.width / maxSize.height : 0
        var fittingSize: CGSize
        if aspectRatio > boundingRatio {
            fittingSize = CGSize(width: maxSize.width, height: maxSize.width / aspectRatio)
        } else {
            fittingSize = CGSize(width: maxSize.height * aspectRatio, height: maxSize.height)
        }

        // Measure the sublayout if it exists.
        let sublayoutMeasurement = sublayout?.measurement(within: fittingSize)
        let sublayouts = [sublayoutMeasurement].compactMap { $0 }

        return LayoutMeasurement(layout: self, size: fittingSize, maxSize: maxSize, sublayouts: sublayouts)
    }

    open func arrangement(within rect: CGRect, measurement: LayoutMeasurement) -> LayoutArrangement {
        let frame = alignment.position(size: measurement.size, in: rect)
        let sublayoutRect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        let sublayouts = measurement.sublayouts.map { (measurement) in
            return measurement.arrangement(within: sublayoutRect)
        }
        return LayoutArrangement(layout: self, frame: frame, sublayouts: sublayouts)
    }
}
