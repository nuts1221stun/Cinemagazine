//
//  CNMImageHelperTests.swift
//  CinemagazineTests
//
//  Created by Li-Erh Chang on 2018/9/17.
//  Copyright © 2018 nuts. All rights reserved.
//

import XCTest
@testable import Cinemagazine

class CNMImageHelperTests: XCTestCase {

    var imageConfiguration: CNMConfigurationImageDataModel?

    override func setUp() {
        super.setUp()
        if let path = Bundle.main.path(forResource: "configuration", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let configuration = try? JSONDecoder().decode(CNMConfigurationDataModel.self, from: data)
                imageConfiguration = configuration?.image
            } catch {
                // handle error
            }
        }
        XCTAssertNotNil(imageConfiguration)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testNilPath() {
        let imageHelper = CNMImageHelper(imageConfiguration: imageConfiguration)
        let path: String? = nil
        let imageUrl = imageHelper?.imageUrl(forType: .backdrop, path: path, fittingWidth: 100)
        XCTAssertTrue(imageUrl == nil)
    }

    func testBackdropPath() {
        let imageHelper = CNMImageHelper(imageConfiguration: imageConfiguration)
        let path: String = "path.jpg"
        let imageUrl = imageHelper?.imageUrl(forType: .backdrop, path: path, fittingWidth: 100)
        XCTAssertEqual(imageUrl, "https://image.tmdb.org/t/p/w300/\(path)")
    }

    func testLogoPath() {
        let imageHelper = CNMImageHelper(imageConfiguration: imageConfiguration)
        let path: String = "path.jpg"
        let imageUrl = imageHelper?.imageUrl(forType: .logo, path: path, fittingWidth: 600)
        XCTAssertEqual(imageUrl, "https://image.tmdb.org/t/p/w500/\(path)")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
