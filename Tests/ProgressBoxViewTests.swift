//
//  ProgressBoxViewTests.swift
//  CustomLoader
//
//  Created by fritzgerald muiseroux on 29/01/2017.
//  Copyright © 2017 fritzgerald muiseroux. All rights reserved.
//

import XCTest
@testable import CustomLoader

class ProgressBoxViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStandarBox() {
        let standardBox = ProgressBoxView.standard
        standardBox.layoutIfNeeded()
        
        XCTAssertEqual(standardBox.intrinsicContentSize, CGSize(width: 100, height: 100))
        XCTAssertEqual(standardBox.backgroundColor, UIColor.lightGray)
        XCTAssertEqual(standardBox.contentView.subviews.count, 3)
    }
    
    func testSystemBox() {
        let standardBox = ProgressBoxView.system(withStyle: .gray)
        standardBox.layoutIfNeeded()
        
        let loadingView = standardBox.loaderView as? UIActivityIndicatorView
        XCTAssertNotNil(loadingView)
        XCTAssertEqual(loadingView?.style, UIActivityIndicatorView.Style.gray)
        XCTAssertTrue((loadingView?.isAnimating)!)
        XCTAssertEqual(standardBox.backgroundColor, UIColor.lightGray)
    }
    
    func testContentCentered() {
        let randomView = UIView()
        randomView.addConstraint(NSLayoutConstraint(item: randomView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 20))
        randomView.addConstraint(NSLayoutConstraint(item: randomView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 20))
        
        let standardBox = ProgressBoxView(loader: randomView)
        standardBox.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        standardBox.label.text = "this is a very long text"
        standardBox.subLabel.text = "small text"
        standardBox.layoutIfNeeded()
        
        XCTAssertEqual(standardBox.contentView.subviews.count, 3)
        XCTAssertEqual(standardBox.contentView.center, standardBox.center)
        XCTAssertEqual(Int(randomView.center.x), Int(standardBox.contentView.frame.width / 2.0))
        XCTAssertEqual(Int(standardBox.label.center.x), Int(standardBox.contentView.frame.width / 2.0))
        XCTAssertEqual(Int(standardBox.subLabel.center.x), Int(standardBox.contentView.frame.width / 2.0))
        
        // make sure that the items are stacked properly
        XCTAssertEqual(randomView.frame.minY, standardBox.contentView.layoutMargins.top)
        XCTAssertEqual(randomView.frame.maxY, standardBox.label.frame.minY)
        XCTAssertEqual(standardBox.label.frame.maxY, standardBox.subLabel.frame.minY)
        XCTAssertEqual(standardBox.subLabel.frame.maxY, standardBox.contentView.frame.height - standardBox.contentView.layoutMargins.bottom)
    }
}
