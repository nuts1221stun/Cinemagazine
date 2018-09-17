//
//  CNMImageSizeDataModelTests.swift
//  CinemagazineTests
//
//  Created by Li-Erh Chang on 2018/9/17.
//  Copyright © 2018 nuts. All rights reserved.
//

import XCTest
@testable import Cinemagazine

class CNMImageSizeDataModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitializationFull() {
        let model = CNMImageSizeDataModel(sizes: ["w300", "w780", "w1280", "original"])
        XCTAssertEqual(model?.sizes, [CNMImageSize.w300, CNMImageSize.w780, CNMImageSize.w1280, CNMImageSize.original])
    }

    func testInitializationFiltered() {
        let model = CNMImageSizeDataModel(sizes: ["w300", "w780", "unknown", "original"])
        XCTAssertEqual(model?.sizes, [CNMImageSize.w300, CNMImageSize.w780, CNMImageSize.original])
    }

    func testSizeMatchingForScreenScale1() {
        var model = CNMImageSizeDataModel(sizes: ["w300", "w780", "original"])
        model?.screenScale = 1
        let size = model?.size(fittingWidth: 300)
        XCTAssertEqual(size, CNMImageSize.w300)
    }

    func testSizeMatchingForScreenScale2() {
        var model = CNMImageSizeDataModel(sizes: ["w300", "w780", "original"])
        model?.screenScale = 2
        let size = model?.size(fittingWidth: 400)
        XCTAssertEqual(size, CNMImageSize.w780)
    }

    func testSizeMatchingOriginalOnly() {
        let model = CNMImageSizeDataModel(sizes: ["original"])
        let size = model?.size(fittingWidth: 400)
        XCTAssertEqual(size, CNMImageSize.original)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
