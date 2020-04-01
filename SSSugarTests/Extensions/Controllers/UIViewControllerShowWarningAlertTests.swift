/*
 
 Tests for UIViewController extension showWarningAlert(message:btnTitle:onSbmt:)
 
 [Done] message
    [Done] regular
    [Done] empty
    [Done] nil
 [Done] empty button title
 [] on submit
 
 */

import XCTest
@testable import SSSugar

class UIViewControllerShowWarningAlertTests: XCTestCase {
    
    let testHelper = UIViewControllerTestHelper()
    var items = UIViewControllerAlertItems(title: NSLocalizedString("Warning"), message: "Error message", button: "Error button")
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
    
    func testNilMessage() {
        items.message = nil
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
    
    func testNilMessageEmptyButtonTitle() {
        items.message = nil
        items.button = ""
        showAlertAndAssert()
    }
    
    func showAlertAndAssert() {
        sut.showAlert(title: items.title, message: items.message, btnTitle: items.button)
        testHelper.assertAlertHasItems(alert: sut.presentedViewController, items)
    }
}
