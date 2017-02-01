//
//  LoadingViewTests.swift
//  CustomLoader
//
//  Created by fritzgerald muiseroux on 29/01/2017.
//  Copyright © 2017 fritzgerald muiseroux. All rights reserved.
//

import XCTest
@testable import CustomLoader

class LoadingViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadingViewSize() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 320))
        let loadingView = LoadingView.standardProgressBox.show(inView: containerView, animated: false, completion: nil)
        containerView.layoutIfNeeded()
        
        XCTAssertEqual(loadingView.frame, containerView.bounds)
    }
    
    func testLoadingCenteredContent() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 320))
        let testView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        testView.addConstraint(NSLayoutConstraint(item: testView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 30))
        testView.addConstraint(NSLayoutConstraint(item: testView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 30))
        
        let loadingView = LoadingView(loaderView: testView)
        _ = loadingView.show(inView: containerView, animated: false, completion: nil)
        containerView.layoutIfNeeded()
        
        XCTAssertEqual(testView.center, containerView.center)
        XCTAssertEqual(testView.frame.size, CGSize(width: 30, height: 30))
    }
    
    func testShowAnimatedInView() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 320))
        
        let expect = expectation(description: "show from view")
        let loadingView = LoadingView.standardProgressBox.show(inView: containerView, animated: true) { _ in
            expect.fulfill()
        }
        containerView.layoutIfNeeded()
        
        self.waitForExpectations(timeout: 5.0) { error in
            XCTAssertNotNil(loadingView.superview)
            XCTAssertEqual(loadingView.alpha, 1.0)
        }
    }
    
    func testShowNotAnimatedInView() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 320))
        
        let loadingView = LoadingView.standardProgressBox.show(inView: containerView, animated: false)
        containerView.layoutIfNeeded()
        
        XCTAssertNotNil(loadingView.superview)
        XCTAssertEqual(loadingView.alpha, 1.0)
    }
    
    func testRemoveFromSuperViewAnimated() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 320))
        
        let loadingView1Loaded = expectation(description: "add loadingView 1")
        let loadingView2Loaded = expectation(description: "add loadingView 1")
        
        let loadingView = LoadingView.standardProgressBox.show(inView: containerView, animated: false) { _ in
            loadingView1Loaded.fulfill()
        }
        let loadingView2 = LoadingView.standardProgressBox.show(inView: containerView, animated: false) { _ in
            loadingView2Loaded.fulfill()
        }
        
        self.waitForExpectations(timeout: 2.0) { error in
            XCTAssertNotNil(loadingView.superview)
            XCTAssertNotNil(loadingView2.superview)
        }
        
        containerView.layoutIfNeeded()
        
        let expect = expectation(description: "removed from super view 1")
        loadingView.removeFromSuperview(animated: false) { finished in
            expect.fulfill()
        }
        
        let expect2 = expectation(description: "removed from super view 2")
        loadingView2.removeFromSuperview(animated: true) { finished in
            expect2.fulfill()
        }
        
        self.waitForExpectations(timeout: 5.0) { error in
            XCTAssertNil(loadingView.superview)
            XCTAssertNil(loadingView2.superview)
        }
    }
    
    func testBoxPresentation() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 320))
        let expect = expectation(description: "loading view loaded")
        let loader = LoadingView.show(inView: containerView, withProgressBox: .standard) { _ in
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNotNil(loader.superview)
            XCTAssertEqual(loader.alpha, 1.0)  
        }
    }
    
    func testRingPresentation() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 320))
        let expect = expectation(description: "loading view loaded")
        let loader = LoadingView.show(inView: containerView, withProgressRing: .dark) { _ in
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNotNil(loader.superview)
            XCTAssertEqual(loader.alpha, 1.0)
        }
    }
    
    func testLoadingViewListRemove() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 320))
        _ = LoadingView.standardProgressBox.show(inView: containerView, animated: false)
        _ = LoadingView.standardProgressBox.show(inView: containerView, animated: false)
        containerView.layoutIfNeeded()
        
        XCTAssertEqual(containerView.subviews.count, 2)
        let expect = expectation(description: "all view removed")
        containerView.removeLoadingViews(animated: false) {
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertEqual(containerView.subviews.count, 0)
        }
    }
    
    func testLightProgressRing() {
        let lightProgressView = LoadingView.lightProgressRing
        XCTAssertNotNil(lightProgressView.progressRing)
        XCTAssertEqual(lightProgressView.progressRing?.outterColor, ProgressRingView.light.outterColor)
        XCTAssertEqual(lightProgressView.progressRing?.innerColor, ProgressRingView.light.innerColor)
    }
    
    func testDarkProgressRing() {
        let lightProgressView = LoadingView.darkProgressRing
        XCTAssertNotNil(lightProgressView.progressRing)
        XCTAssertEqual(lightProgressView.progressRing?.outterColor, ProgressRingView.dark.outterColor)
        XCTAssertEqual(lightProgressView.progressRing?.innerColor, ProgressRingView.dark.innerColor)
    }
    
    func testStandardProgressBox() {
        let lightProgressView = LoadingView.standardProgressBox
        XCTAssertNotNil(lightProgressView.progressBox)
        XCTAssertEqual(lightProgressView.progressBox?.backgroundColor, UIColor.lightGray)
        let progressRing = lightProgressView.progressBox?.loaderView as? ProgressRingView
        XCTAssertNotNil(progressRing)
        XCTAssertEqual(progressRing?.outterColor, ProgressRingView.light.outterColor)
        XCTAssertEqual(progressRing?.innerColor, ProgressRingView.light.innerColor)
    }
    
    func testSystemWithStyle() {
        let view = LoadingView.system(withStyle: .whiteLarge)
        let activityIndicator = view.loaderView as? UIActivityIndicatorView
        XCTAssertNotNil(activityIndicator)
        XCTAssertTrue((activityIndicator?.isAnimating)!)
    }
    
    func testBoxWithStyle() {
        let view = LoadingView.systemBox(withStyle: .white)
        XCTAssertNotNil(view.progressBox)
    }
}
