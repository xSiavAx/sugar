/*
 Tests for UIViewController extension showErrorAlert(message:btnTitle:onSbmt:)
 
 [Done] message
    [Done] regular
    [Done] empty
 [Done] empty button title
 [] on submit
 
 TODO: check submit closure
 */

import XCTest
@testable import SSSugar

class UIViewControllerShowErrorAlertTests: XCTestCase {
    let testHelper = UIViewControllerTestHelper()
    var items = UIViewControllerAlertItems(title: NSLocalizedString("Error"), message: "Error message", button: "Error button")
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
        sut.showErrorAlert(message: items.message!, btnTitle: items.button)
        testHelper.assertAlertHasItems(alert: sut.presentedViewController, items)
    }
}
