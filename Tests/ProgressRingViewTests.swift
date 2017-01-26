//
//  ProgressRingViewTests.swift
//  CustomLoader
//
//  Created by fritzgerald muiseroux on 26/01/2017.
//  Copyright © 2017 fritzgerald muiseroux. All rights reserved.
//

import XCTest
@testable import CustomLoader

class ProgressRingViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIntrinsicContentSize() {

        let ringView = ProgressRingView()
        let defaultSize = ringView.intrinsicContentSize
        XCTAssertEqual(defaultSize.width, 40)
        XCTAssertEqual(defaultSize.height, 40)
    }
    
    func testColorCustomization() {
        
        let ringView = ProgressRingView()
        ringView.outterColor = .red
        ringView.innerColor = .white
        ringView.lineWidth = 10
        ringView.layoutSubviews()
        
        XCTAssertNotNil(ringView.layer.sublayers)
        if let sublayers = ringView.layer.sublayers {
            XCTAssertEqual(sublayers.count, 2)
            
            guard let outterLayer = sublayers[0] as? CAShapeLayer,
                let innerLayer = sublayers[1] as? CAShapeLayer else {
                 XCTFail("outterLayer and outterLayer must be of type CAShapeLayer")
                    return
            }
            
            XCTAssertEqual(outterLayer.strokeColor!, UIColor.red.cgColor)
            XCTAssertEqual(innerLayer.strokeColor!, UIColor.white.cgColor)
            XCTAssertEqual(outterLayer.lineWidth, 10)
            XCTAssertEqual(innerLayer.lineWidth, 10)
            
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let testView = ProgressRingView.dark
            testView.layoutSubviews()
        }
    }
    
}
