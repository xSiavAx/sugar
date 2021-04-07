/*
 Tests for UIViewController extension showAlert(title:message:btnTitle:onSbmt:)
 
 [title] variations for the alert title (passed as an argument to the method)
    [regular] "Alert title"
    [empty] ""
    [nil] nil
 [message] variations for the alert message (passed as an argument to the method)
    [regular] "Alert message"
    [empty] ""
    [nil] nil
 [button title] variations for the alert batton title (passed as an argument btnTitle to the method)
    [regular] "Alert button"
    [empty] ""
 
 [Done] regular title + regular message
 [Done] regular title + empty message
 [Done] regular title + nil message
 [Done] empty title + regular message
 [Done] empty title + empty message
 [Done] empty title + nil message
 [Done] nil title + regular message
 [Done] nil title + empty message
 [Done] regular title + regular message + empty button title
 [Done] regular title + empty message + empty button title
 [Done] regular title + nil message + empty button title
 [Done] empty title + regular message + empty button title
 [Done] empty title + empty message + empty button title
 [Done] empty title + nil message + empty button title
 [Done] nil title + regular message + empty button title
 [Done] nil title + empty message + empty button title
 [fatalError] nil title + nil message
 [] on submit
 
 TODO: check submit closure
 */

import XCTest
@testable import SSSugarUIKit

class UIViewControllerShowAlertTests: XCTestCase {
    let testHelper = UIViewControllerTestHelper()
    var items = AlertTestItems(title: "Alert title", message: "Alert message", button: "Alert button")
    let sut = UIViewController()

    override func setUp() {
        testHelper.setup(withViewController: sut)
    }
    
    func testRegularTitleRegularMessage() {
        showAlertAndAssert()
    }
    
    func testRegularTitleEmptyMessage() {
        items.message = ""
        showAlertAndAssert()
    }
    
    func testRegularTitleNilMessage() {
        items.message = nil
        showAlertAndAssert()
    }
    
    func testEmptyTitleRegularMessage() {
        items.title = ""
        showAlertAndAssert()
    }
    
    func testEmptyTitleEmptyMessage() {
        items.title = ""
        items.message = ""
        showAlertAndAssert()
    }
    
    func testEmptyTitleNilMessage() {
        items.title = ""
        items.message = nil
        showAlertAndAssert()
    }
    
    func testNilTitleRegularMessage() {
        items.title = nil
        showAlertAndAssert()
    }
    
    func testNilTitleEmptyMessage() {
        items.title = nil
        items.message = ""
        showAlertAndAssert()
    }
    
    func testRegularTitleRegularMessageEmptyButtonTitle() {
        items.button = ""
        showAlertAndAssert()
    }
    
    func testRegularTitleEmptyMessageEmptyButtonTitle() {
        items.button = ""
        items.message = ""
        showAlertAndAssert()
    }
    
    func testRegularTitleNilMessageEmptyButtonTitle() {
        items.button = ""
        items.message = nil
        showAlertAndAssert()
    }
    
    func testEmptyTitleRegularMessageEmptyButtonTitle() {
        items.button = ""
        items.title = ""
        showAlertAndAssert()
    }
    
    func testEmptyTitleEmptyMessageEmptyButtonTitle() {
        items.button = ""
        items.title = ""
        items.message = ""
        showAlertAndAssert()
    }
    
    func testEmptyTitleNilMessageEmptyButtonTitle() {
        items.button = ""
        items.title = ""
        items.message = nil
        showAlertAndAssert()
    }
    
    func testNilTitleRegularMessageEmptyButtonTitle() {
        items.button = ""
        items.title = nil
        showAlertAndAssert()
    }
    
    func testNilTitleEmptyMessageEmptyButtonTitle() {
        items.button = ""
        items.title = nil
        items.message = ""
        showAlertAndAssert()
    }
    
    func showAlertAndAssert() {
        sut.showAlert(title: items.title, message: items.message, btnTitle: items.button)
        testHelper.assertAlertHasItems(alert: sut.presentedViewController, items)
    }
}
