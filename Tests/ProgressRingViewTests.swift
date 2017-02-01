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
        ringView.isIndeterminate = true
        ringView.layoutIfNeeded()
        
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
            
            let outterAnimation = outterLayer.animation(forKey: "rotation") as? CABasicAnimation
            let innerAnimation = innerLayer.animation(forKey: "rotation") as? CABasicAnimation
            
            XCTAssertNotNil(outterAnimation)
            XCTAssertNotNil(innerAnimation)
            
            // Make sure that the animations repeat forever
            XCTAssertEqual(outterAnimation?.repeatCount, Float.greatestFiniteMagnitude)
            XCTAssertEqual(innerAnimation?.repeatCount, Float.greatestFiniteMagnitude)
        }
    }
    
    func testDeterminateRing() {
        
        let ringView = ProgressRingView()
        ringView.outterColor = .red
        ringView.innerColor = .white
        ringView.lineWidth = 10
        ringView.isIndeterminate = false
        ringView.minimumValue = -2
        ringView.maximumValue = 0
        ringView.value = -1
        
        XCTAssertEqual(ringView.valueRatio, 0.5)
        ringView.layoutIfNeeded()
        
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
            
            let outterAnimation = outterLayer.animation(forKey: "rotation") as? CABasicAnimation
            let innerAnimation = innerLayer.animation(forKey: "rotation") as? CABasicAnimation
            
            XCTAssertNil(outterAnimation)
            XCTAssertNil(innerAnimation)
            XCTAssert(outterLayer.animationKeys() == nil || outterLayer.animationKeys()?.count == 0)
        }
    }

    
    func testLightStyle() {
        
        let darkRing = ProgressRingView.light
        XCTAssertEqual(darkRing.outterColor, UIColor.white)
        XCTAssertEqual(darkRing.innerColor, UIColor.darkGray)
        XCTAssertEqual(darkRing.lineWidth, 3)
        XCTAssertTrue(darkRing.isIndeterminate)
    }
    
    func testDarkStyle() {
        
        let lightRing = ProgressRingView.dark
        XCTAssertEqual(lightRing.outterColor, UIColor.black)
        XCTAssertEqual(lightRing.innerColor, UIColor.darkGray)
        XCTAssertEqual(lightRing.lineWidth, 3)
        XCTAssertTrue(lightRing.isIndeterminate)
    }
    
    func testXibInitialization() {
        let bundle = Bundle(for: ProgressRingViewTests.self)
        let nib = UINib(nibName: "ProgressRingViewXibTest", bundle: bundle)
        let loadingRing = nib.instantiate(withOwner: nil, options: nil).first as? ProgressRingView
        XCTAssertNotNil(loadingRing)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let testView = ProgressRingView.dark
            testView.layoutSubviews()
        }
    }
    
    func testRingValue() {
        
        let ringView = ProgressRingView()
        ringView.outterColor = .red
        ringView.innerColor = .white
        ringView.lineWidth = 10
        ringView.isIndeterminate = false
        ringView.minimumValue = -2
        ringView.maximumValue = 0
        ringView.value = -1
        
        XCTAssertEqual(ringView.value, -1)
        XCTAssertEqual(ringView.valueRatio, 0.5)
        ringView.value = -3
        XCTAssertEqual(ringView.value, -2)
        ringView.value = 3
        XCTAssertEqual(ringView.value, 0)
        
    }
    
    func testProgressRingProgression() {
        XCTAssertEqual(ProgressRingView.valueRatio(minumum: 0, maximum: 1, value: 0.5), 0.5)
        XCTAssertEqual(ProgressRingView.valueRatio(minumum: -2, maximum: 0, value: -1.5), 0.25)
        XCTAssertEqual(round(ProgressRingView.valueRatio(minumum: 0.25, maximum: 0.5, value: 0.30), toDecimalPlaces: 2), 0.2)
    }
    
    func round(_ value: Double, toDecimalPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (value * divisor).rounded() / divisor
    }
}
