/*
 
 Tests for UIViewController extension dismissPresented(animated:onFinish)
 
 [Done] presented
 [Done] not presented
 [Done] animated
 [Done] not animated
 [Done] completion
 
 */

import XCTest

class UIViewControllerDismissPresentedAnimatedOnFinish: XCTestCase {

    let testHelper = UIViewControllerTestHelper()
    let sut = DismissableViewController()
    
    override func setUp() {
        testHelper.setup(withViewController: sut)
    }
    
    func testPresentedAnimated() {
        let expectation = XCTestExpectation()
        
        sut.presentViewControler()
        sut.dismissPresented(animated: true) { expectation.fulfill() }
        XCTAssertTrue(sut.isDismissed)
        XCTAssertEqual(sut.isDismissAnimated, true)
        wait(for: [expectation], timeout: 1)
    }
    
    func testPresentedNotAnimated() {
        let expectation = XCTestExpectation()
        
        sut.presentViewControler()
        sut.dismissPresented { expectation.fulfill() }
        XCTAssertTrue(sut.isDismissed)
        XCTAssertEqual(sut.isDismissAnimated, false)
        wait(for: [expectation], timeout: 1)
    }
    
    func testNotPresentedAnimated() {
        let expectation = XCTestExpectation()
        
        sut.dismissPresented(animated: true) { expectation.fulfill() }
        XCTAssertFalse(sut.isDismissed)
        XCTAssertNil(sut.isDismissAnimated)
        wait(for: [expectation], timeout: 1)
    }
    
    func testNotPresentedNotAnimated() {
        let expectaiton = XCTestExpectation()
        
        sut.dismissPresented { expectaiton.fulfill() }
        XCTAssertFalse(sut.isDismissed)
        XCTAssertNil(sut.isDismissAnimated)
        wait(for: [expectaiton], timeout: 1)
    }
    
}
