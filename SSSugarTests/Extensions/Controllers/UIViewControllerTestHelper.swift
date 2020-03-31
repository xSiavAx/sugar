/*
 
 Tests for UIViewController extension
 
 Alerts
 [Done] showAlert(title:message:btnTitle:onSbmt:)
 [Done] showErrorAlert(message:btnTitle:onSbmt:)
 [Done] showWarningAlert(message:btnTitle:onSbmt:)
    
 Keyboard
 [] registerForKBNotifications()
 [] unregisterFromKBNotifications()
 [] kbDidChangeHeightTo(_:)
 [] kbDidShow(notification:)
 [] dbDidHide(notification:)
 
 Controllers Relations
 [] dismissPresented(animated:onFinish:)
 [] rootController()
 
 */

import XCTest

struct UIViewControllerTestHelper {
    
    let rootWindow = UIWindow()
    
    func setup(withViewController viewController: UIViewController) {
        rootWindow.rootViewController = viewController
        rootWindow.isHidden = false
    }
    
    func assertAlertHasItems(alert: UIViewController?, _ items: UIViewControllerAlertItems) {
        guard let alertVC = alert as? UIAlertController,
            let action = alertVC.actions.first else {
                XCTFail()
                return
        }
        
        XCTAssertEqual(alertVC.title, items.title)
        XCTAssertEqual(alertVC.message, items.message)
        XCTAssertEqual(action.title, items.button)
    }
}

struct UIViewControllerAlertItems {
    var title: String?
    var message: String?
    var button: String
}
