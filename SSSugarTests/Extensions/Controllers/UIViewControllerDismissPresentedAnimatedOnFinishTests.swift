/*
 Tests for UIViewController extension dismissPresented(animated:onFinish:)
 
 [Done] presented
 [Done] not presented
 [Done] animated
 [Done] not animated
 [Done] completion
 */

//TODO: [Review] I can't find `complition` cases

import XCTest
@testable import SSSugar

class UIViewControllerDismissPresentedAnimatedOnFinishTests: XCTestCase {
    let testHelper = UIViewControllerTestHelper()
    let sut = DismissableViewController()
    
    override func setUp() {
        testHelper.setup(withViewController: sut)
    }
    
    func testPresentedAnimated() {
        let expectation = XCTestExpectation()
        
        sut.presentViewControler()
        sut.dismissPresented(animated: true) { expectation.fulfill() }
        //TODO: [Review] Separate testing logic from checks with empty row
        //TODO: [Review] XCTAssert(sut.isDismissed)
        XCTAssertTrue(sut.isDismissed)
        //TODO: [Review] XCTAssert(sut.isDismissAnimated)
        XCTAssertEqual(sut.isDismissAnimated, true)
        wait(for: [expectation], timeout: 1)
        //TODO: [Review] Waiting for what?
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
        //TODO: [Review] Redurant case
        let expectaiton = XCTestExpectation()
        
        sut.dismissPresented { expectaiton.fulfill() }
        XCTAssertFalse(sut.isDismissed)
        XCTAssertNil(sut.isDismissAnimated)
        wait(for: [expectaiton], timeout: 1)
    }
}

class DismissableViewController: UIViewController {
    var isDismissed = false
    var isDismissAnimated: Bool? = nil
    
    //TODO: [Review] Why `flag`? Why not just `animated`?
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        //TODO: [Review] call super?
        isDismissed = true
        isDismissAnimated = flag
        completion?()
    }
    
    func presentViewControler() {
        present(UIViewController(), animated: false)
    }
}
