/*
 
 Tests for UIViewController extension
 
 Alerts
 [] showAlert(title:message:btnTitle:onSbmt:)
 [] showErrorAlert(message:btnTitle:onSbmt:)
 [] showWarningAlert(message:btnTitle:onSbmt:)
    
 Keyboard
 [Done] registerForKBNotifications()
 [] unregisterFromKBNotifications()
 [] kbDidChangeHeightTo(_:)
 
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
    
    func makeUserInfos() -> [[AnyHashable : Any]] {
        var userInfos = [[AnyHashable : Any]]()
        
        for originPair in UIViewControllerNotificationItems.allItems {
            for sizePair in UIViewControllerNotificationItems.allItems {
                userInfos.append(makeUserInfo(origin: originPair, size: sizePair))
            }
        }
        return userInfos
    }
    
    func makeUserInfo(origin: UIViewControllerNotificationItems, size: UIViewControllerNotificationItems) -> [AnyHashable : Any] {
        let rect = CGRect(origin: origin.makePoint(), size: size.makeSize())
        
        return [UIResponder.keyboardFrameEndUserInfoKey : NSValue(cgRect: rect)]
    }
    
    func post(name: Notification.Name, userInfo: [AnyHashable : Any]? = nil) {
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
}


struct UIViewControllerAlertItems {
    var title: String?
    var message: String?
    var button: String
}


class NotifiableViewController: UIViewController {
    var isNotified = false
    
    override func kbDidChangeHeightTo(_ height: CGFloat) {
        isNotified = true
    }
    
    @objc func setNotifiedTrue(_ userInfo: [AnyHashable : Any]) {
        isNotified = true
    }
}

struct UIViewControllerNotificationItems {
    
    enum Value {
        static let greaterThanZero: CGFloat = 4
        static let lessThanZero: CGFloat = -5
        static let zero: CGFloat = 0
    }
    
    static let allValues = [Value.greaterThanZero, Value.lessThanZero, Value.zero]
    static let allItems = makeAvailable()
    
    let first: CGFloat
    let second: CGFloat
    
    private static func makeAvailable() -> [UIViewControllerNotificationItems] {
        var availableValuePairs = [UIViewControllerNotificationItems]()
        
        for first in Self.allValues {
            for second in Self.allValues {
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
