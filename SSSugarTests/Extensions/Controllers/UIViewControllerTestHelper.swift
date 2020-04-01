/*
 
 Tests for UIViewController extension
 
 Alerts
 [] showAlert(title:message:btnTitle:onSbmt:)
 [] showErrorAlert(message:btnTitle:onSbmt:)
 [] showWarningAlert(message:btnTitle:onSbmt:)
    
 Keyboard
 [Done] registerForKBNotifications()
 [Done] unregisterFromKBNotifications()
 [Done] kbDidChangeHeightTo(_:)
 
 Controllers Relations
 [] dismissPresented(animated:onFinish:)
 [] rootController()
 
 */

import XCTest
@testable import SSSugar

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
    
    private func makeUserInfo(origin: UIViewControllerNotificationItems, size: UIViewControllerNotificationItems) -> [AnyHashable : Any] {
        let rect = CGRect(origin: origin.makePoint(), size: size.makeSize())
        
        return [UIResponder.keyboardFrameEndUserInfoKey : NSValue(cgRect: rect)]
    }
    
    func makeUserInfo() -> [AnyHashable : Any] {
        let origin = UIViewControllerNotificationItems(first: 100, second: 800)
        let size = UIViewControllerNotificationItems(first: 400, second: 600)
        
        return makeUserInfo(origin: origin, size: size)
    }
    
    func makeUserInfos() -> [[AnyHashable : Any]] {
        var userInfos = [[AnyHashable : Any]]()
        
        for originItems in UIViewControllerNotificationItems.allItems {
            for sizeItems in UIViewControllerNotificationItems.allItems {
                userInfos.append(makeUserInfo(origin: originItems, size: sizeItems))
            }
        }
        return userInfos
    }
    
    func getHeightFromUserInfo(_ userInfo: [AnyHashable : Any]) -> CGFloat {
        if let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            return value.cgRectValue.height
        } else {
            fatalError("unavailable user info")
        }
    }
    
    func post(name: Notification.Name, userInfo: [AnyHashable : Any]? = nil) {
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
    
    func postKeyboardDidShowNotification(userInfo: [AnyHashable : Any]? = nil) {
        post(name: UIResponder.keyboardDidShowNotification, userInfo: userInfo)
    }
    
    func postKeyboardDidHideNotification(userInfo: [AnyHashable : Any]? = nil) {
        post(name: UIResponder.keyboardDidHideNotification, userInfo: userInfo)
    }
}


struct UIViewControllerAlertItems {
    var title: String?
    var message: String?
    var button: String
}


class NotifiableViewController: UIViewController {
    
    static let defaultKeyboardHight: CGFloat = -10
    
    var isNotified = false
    var keyboardHeight = NotifiableViewController.defaultKeyboardHight
    
    override func kbDidChangeHeightTo(_ height: CGFloat) {
        isNotified = true
        keyboardHeight = height
    }
    
    @objc func setNotifiedTrue(_ userInfo: [AnyHashable : Any]) {
        isNotified = true
    }
    
    func addDidShowNotificationObserver() {
        let name = UIResponder.keyboardDidShowNotification
        let selector = #selector(setNotifiedTrue(_:))
        
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func addDidHideNotificationObserver() {
        let name = UIResponder.keyboardDidHideNotification
        let selector = #selector(setNotifiedTrue(_:))
        
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func reset() {
        isNotified = false
        keyboardHeight = NotifiableViewController.defaultKeyboardHight
    }
    
}


struct UIViewControllerNotificationItems {
    
    static let allItems = getItems(with: 434, -57, 0)
    
    let first: CGFloat
    let second: CGFloat
    
    private static func getItems(with values: CGFloat...) -> [UIViewControllerNotificationItems] {
        var availableValuePairs = [UIViewControllerNotificationItems]()
        
        for first in values {
            for second in values {
                availableValuePairs.append(UIViewControllerNotificationItems(first: first, second: second))
            }
        }
        return availableValuePairs
    }
    
    func makeSize() -> CGSize {
        CGSize(width: first, height: second)
    }
    
    func makePoint() -> CGPoint {
        CGPoint(x: first, y: second)
    }
    
}
