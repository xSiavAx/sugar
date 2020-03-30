/*
 
 Tests for UIViewController extension showAlert(title:message:btnTitle:onSbmt:)
 
 [Done] regular title regular message
 [Done] regular title empty message
 [Done] regular title nil message
 [Done] empty title regular message
 [Done] empty title empty message
 [Done] empty title nil message
 [Done] nil title regular message
 [Done] nil title empty message
 [fatalError] nil title nil message
 [Done] empty button title
 
 */

import XCTest
@testable import SSSugar

class UIViewControllerShowAlertTitleMessageBtnTittleOnSbmt: XCTestCase {
    
    let testHelper = UIViewControllerTestHelper()
    var items = UIViewControllerAlertItems()
    let sut = UIViewController()

    override func setUp() {
        testHelper.setup(withViewController: sut)
    }
    
    func testRegularTitleRegularMessage() {
        showAndAssert()
    }
    
    func testRegularTitleEmptyMessage() {
        items.message = ""
        showAndAssert()
    }
    
    func testRegularTitleNilMessage() {
        items.message = nil
        showAndAssert()
    }
    
    func testEmptyTitleRegularMessage() {
        items.title = ""
        showAndAssert()
    }
    
    func testEmptyTitleEmptyMessage() {
        items.title = ""
        items.message = ""
        showAndAssert()
    }
    
    func testEmptyTitleNilMessage() {
        items.title = ""
        items.message = nil
        showAndAssert()
    }
    
    func testNilTitleRegularMessage() {
        items.title = nil
        showAndAssert()
    }
    
    func testNilTitleEmptyMessage() {
        items.title = nil
        items.message = ""
        showAndAssert()
    }
    
    func testRegularTitleRegularMessageEmptyButtonTitle() {
        items.action = ""
        showAndAssert()
    }
    
    func testRegularTitleEmptyMessageEmptyButtonTitle() {
        items.action = ""
        items.message = ""
        showAndAssert()
    }
    
    func testRegularTitleNilMessageEmptyButtonTitle() {
        items.action = ""
        items.message = nil
        showAndAssert()
    }
    
    func testEmptyTitleRegularMessageEmptyButtonTitle() {
        items.action = ""
        items.title = ""
        showAndAssert()
    }
    
    func testEmptyTitleEmptyMessageEmptyButtonTitle() {
        items.action = ""
        items.title = ""
        items.message = ""
        showAndAssert()
    }
    
    func testEmptyTitleNilMessageEmptyButtonTitle() {
        items.action = ""
        items.title = ""
        items.message = nil
        showAndAssert()
    }
    
    func testNilTitleRegularMessageEmptyButtonTitle() {
        items.action = ""
        items.title = nil
        showAndAssert()
    }
    
    func testNilTitleEmptyMessageEmptyButtonTitle() {
        items.action = ""
        items.title = nil
        items.message = ""
        showAndAssert()
    }
    
    func showAndAssert() {
        sut.showAlert(title: items.title, message: items.message, btnTitle: items.action)
        assertPresentedAlertHasItems()
    }
    
    func assertPresentedAlertHasItems() {
        guard let alertVC = sut.presentedViewController as? UIAlertController,
            let action = alertVC.actions.first else {
                XCTFail()
                return
        }
        
        XCTAssertEqual(alertVC.title, items.title)
        XCTAssertEqual(alertVC.message, items.message)
        XCTAssertEqual(action.title, items.action)
    }
}
