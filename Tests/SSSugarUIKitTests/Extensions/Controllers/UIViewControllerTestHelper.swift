/*
 Tests for UIViewController extension
 
 Alerts
 [Partially] showAlert(title:message:btnTitle:onSbmt:)
 [Partially] showErrorAlert(message:btnTitle:onSbmt:)
 [Partially] showWarningAlert(message:btnTitle:onSbmt:)
    
 Keyboard
 [Done] registerForKBNotifications()
 [Done] unregisterFromKBNotifications()
 [Done] kbDidChangeHeightTo(_:)
 
 Controllers Relations
 [Done] dismissPresented(animated:onFinish:)
 [] rootController()
 */

import XCTest
@testable import SSSugarUIKIt

struct UIViewControllerTestHelper {
    let window = UIWindow()
    
    func setup(withViewController viewController: UIViewController) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    func assertAlertHasItems(alert: UIViewController?, _ items: AlertTestItems) {
        guard let alertVC = alert as? UIAlertController,
            let action = alertVC.actions.first else {
                XCTFail()
                return
        }
        
        XCTAssertEqual(alertVC.title, items.title)
        XCTAssertEqual(alertVC.message, items.message)
        XCTAssertEqual(action.title, items.button)
    }
    
    private func post(name: Notification.Name, userInfo: [AnyHashable : Any]? = nil) {
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
    
    private func notificationKBUserInfo(origin: ValuesPair, size: ValuesPair) -> [AnyHashable : Any] {
        let rect = CGRect(origin: origin.point(), size: size.size())
        
        return [UIResponder.keyboardFrameEndUserInfoKey : NSValue(cgRect: rect)]
    }
    
    func defaultNotificationKBUserInfo() -> [AnyHashable : Any] {
        let origin = ValuesPair(first: 100, second: 800)
        let size = ValuesPair(first: 400, second: 600)
        
        return notificationKBUserInfo(origin: origin, size: size)
    }
    
    func defaultNotificationKBUserInfos() -> [[AnyHashable : Any]] {
        let valuesPairs = ValuesPair.valuesPairsCombinations(434, -57, 0)
        var userInfos = [[AnyHashable : Any]]()
        
        for originItems in valuesPairs {
            for sizeItems in valuesPairs {
                userInfos.append(notificationKBUserInfo(origin: originItems, size: sizeItems))
            }
        }
        return userInfos
    }
    
    func heightFromUserInfo(_ userInfo: [AnyHashable : Any]) -> CGFloat {
        if let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            return value.cgRectValue.height
        } else {
            fatalError("unavailable user info")
        }
    }
    
    func postKBDidShowNotification(userInfo: [AnyHashable : Any]?) {
        post(name: UIResponder.keyboardDidShowNotification, userInfo: userInfo)
    }
    
    func postKBDidHideNotification(userInfo: [AnyHashable : Any]?) {
        post(name: UIResponder.keyboardDidHideNotification, userInfo: userInfo)
    }
    
    func postCustomNotification(userInfo: [AnyHashable : Any]) {
        post(name: Notification.Name("CustomNotificationName"), userInfo: userInfo)
    }
}

extension UIViewControllerTestHelper {
    private struct ValuesPair {
        let first: CGFloat
        let second: CGFloat
        
        static func valuesPairsCombinations(_ values: CGFloat...) -> [ValuesPair] {
            var valuesPairs = [ValuesPair]()
            
            for first in values {
                for second in values {
                    valuesPairs.append(ValuesPair(first: first, second: second))
                }
            }
            return valuesPairs
        }
        
        func size() -> CGSize {
            CGSize(width: first, height: second)
        }
        
        func point() -> CGPoint {
            CGPoint(x: first, y: second)
        }
    }
}

struct AlertTestItems {
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
        super.kbDidChangeHeightTo(height)
    }
    
    @objc func setNotifiedTrue() {
        isNotified = true
    }
    
    func addDidShowNotificationObserver() {
        let name = UIResponder.keyboardDidShowNotification
        let selector = #selector(setNotifiedTrue)
        
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func addDidHideNotificationObserver() {
        let name = UIResponder.keyboardDidHideNotification
        let selector = #selector(setNotifiedTrue)
        
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
