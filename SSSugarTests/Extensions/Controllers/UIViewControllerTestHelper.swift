/*
 
 Tests for UIViewController extension
 
 Alerts
 [Done] showAlert(title:message:btnTitle:onSbmt:)
 [] showErrorAlert(message:btnTitle:onSbmt:)
 [] showWarningAlert(message:btnTitle:onSbmt:)
    
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

import UIKit

struct UIViewControllerTestHelper {
    
    let rootWindow = UIWindow()
    
    func setup(withViewController viewController: UIViewController) {
        rootWindow.rootViewController = viewController
        rootWindow.isHidden = false
    }
}

struct UIViewControllerAlertItems {
    var title: String? = "Alert title"
    var message: String? = "Alert message"
    var action: String = "Alert action"
}
