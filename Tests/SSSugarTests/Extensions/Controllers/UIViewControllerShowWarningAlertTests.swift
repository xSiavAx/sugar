/*
 Tests for UIViewController extension showWarningAlert(message:btnTitle:onSbmt:)
 
 [message] variations for the alert message (passed as an argument to the method)
    [regular] "Alert message"
    [empty] ""
 [button title] variations for the alert batton title (passed as an argument btnTitle to the method)
    [regular] "Alert button"
    [empty] ""
 
 [Done] regular message
 [Done] empty message
 [Done] regular message + empty button title
 [Done] empty message + empty button title
 [] on submit
 
 TODO: check submit closure
 */

import XCTest
@testable import SSSugar

class UIViewControllerShowWarningAlertTests: XCTestCase {
    let testHelper = UIViewControllerTestHelper()
    var items = AlertTestItems(title: NSLocalizedString("Warning"), message: "Error message", button: "Error button")
    let sut = UIViewController()
    
    override func setUp() {
        testHelper.setup(withViewController: sut)
    }
    
    func testRegularMessage() {
        showAlertAndAssert()
    }
    
    func testEmptyMessage() {
        items.message = ""
        showAlertAndAssert()
    }
    
    func testRegularMessageEmptyButtonTitle() {
        items.button = ""
        showAlertAndAssert()
    }
    
    func testEmptyMessageEmptyButtonTitle() {
        items.message = ""
        items.button = ""
        showAlertAndAssert()
    }
    
    func showAlertAndAssert() {
        sut.showWarningAlert(message: items.message!, btnTitle: items.button)
        testHelper.assertAlertHasItems(alert: sut.presentedViewController, items)
    }
}
