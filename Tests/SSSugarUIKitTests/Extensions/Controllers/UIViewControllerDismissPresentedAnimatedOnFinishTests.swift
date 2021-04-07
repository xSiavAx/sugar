/*
 Tests for dismissPresented(animated:onFinish:) method in UIViewController extension
 
 [Done] presented animated
 [Done] presented not animated
 [Done] not presented
 [Done] completion
 [Done] completion not presented
 */

import XCTest
@testable import SSSugarUIKIt

class UIViewControllerDismissPresentedAnimatedOnFinishTests: XCTestCase {
    let testHelper = UIViewControllerTestHelper()
    let sut = DismissableViewController()
    
    override func setUp() {
        testHelper.setup(withViewController: sut)
    }
    
    func testPresentedAnimated() {
        sut.presentViewControler()
        sut.dismissPresented(animated: true, onFinish: nil)
        
        XCTAssert(sut.isDismissed)
        XCTAssertEqual(sut.isDismissAnimated, true)
    }
    
    func testPresentedNotAnimated() {
        sut.presentViewControler()
        sut.dismissPresented(onFinish: nil)
        
        XCTAssert(sut.isDismissed)
        XCTAssertEqual(sut.isDismissAnimated, false)
    }
    
    func testNotPresented() {
        sut.dismissPresented(onFinish: nil)
        
        XCTAssertFalse(sut.isDismissed)
    }
    
    func testCompletion() {
        let completionExpectation = XCTestExpectation()
        
        sut.presentViewControler()
        sut.dismissPresented { completionExpectation.fulfill() }
        
        wait(for: [completionExpectation], timeout: 1)
    }
    
    func testCompletionNotPresented() {
        let completionExpectataion = XCTestExpectation()
        
        sut.dismissPresented { completionExpectataion.fulfill() }
        
        wait(for: [completionExpectataion], timeout: 1)
    }
}

class DismissableViewController: UIViewController {
    var isDismissed = false
    var isDismissAnimated: Bool? = nil
    
    override func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: false)
        isDismissed = true
        isDismissAnimated = animated
        completion?()
    }
    
    func presentViewControler() {
        present(UIViewController(), animated: false)
    }
}
