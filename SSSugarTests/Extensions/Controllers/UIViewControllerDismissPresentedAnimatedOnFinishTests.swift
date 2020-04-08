/*
 Tests for UIViewController extension dismissPresented(animated:onFinish:)
 
 [Done] presented
 [Done] not presented
 [Done] animated
 [Done] not animated
 [Done] completion
 */

import XCTest
@testable import SSSugar

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
}

class DismissableViewController: UIViewController {
    var isDismissed = false
    var isDismissAnimated: Bool? = nil
    
    override func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: animated, completion: nil)
        isDismissed = true
        isDismissAnimated = animated
        completion?()
    }
    
    func presentViewControler() {
        present(UIViewController(), animated: false)
    }
}
