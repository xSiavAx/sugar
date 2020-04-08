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
@testable import SSSugar

struct UIViewControllerTestHelper {
    let rootWindow = UIWindow()
    
    func setup(withViewController viewController: UIViewController) {
        rootWindow.rootViewController = viewController
        rootWindow.isHidden = false
        //TODO: [Review] Why not makeKeyAndVisible?
        //RODO: If it conflicts with main window, try to inject it here
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
    
    //TODO: [Review] Usually, verb 'make' is redurant, and getters like methods should start with noun. U may use 'make' to underline hight complexity of method or it's buiding behaviour.
    //TODO: [Review] Method name doesn't represent its logic
    private func makeUserInfo(origin: UIViewControllerNotificationItems, size: UIViewControllerNotificationItems) -> [AnyHashable : Any] {
        let rect = CGRect(origin: origin.makePoint(), size: size.makeSize())
        
        return [UIResponder.keyboardFrameEndUserInfoKey : NSValue(cgRect: rect)]
    }
    
    //TODO: [Review] Method name doesn't represent its logic
    func makeUserInfo() -> [AnyHashable : Any] {
        let origin = UIViewControllerNotificationItems(first: 100, second: 800)
        let size = UIViewControllerNotificationItems(first: 400, second: 600)
        
        return makeUserInfo(origin: origin, size: size)
    }
    
    //TODO: [Review] Method name doesn't represent its logic
    func makeUserInfos() -> [[AnyHashable : Any]] {
        var userInfos = [[AnyHashable : Any]]()
        
        for originItems in UIViewControllerNotificationItems.allItems {
            for sizeItems in UIViewControllerNotificationItems.allItems {
                userInfos.append(makeUserInfo(origin: originItems, size: sizeItems))
            }
        }
        return userInfos
    }
    
    //TODO: [Review] Same story as with 'make'. But unlike 'make', 'get' may by used if noun already represents another getter.
    func getHeightFromUserInfo(_ userInfo: [AnyHashable : Any]) -> CGFloat {
        if let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            return value.cgRectValue.height
        } else {
            fatalError("unavailable user info")
        }
    }
    
    //TODO: [Review] Looks like private method
    func post(name: Notification.Name, userInfo: [AnyHashable : Any]? = nil) {
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
    
    //TODO: [Review] May be shortcuted to 'postKBHideNotification' (unnecessary)
    func postKeyboardDidShowNotification(userInfo: [AnyHashable : Any]? = nil) {
        post(name: UIResponder.keyboardDidShowNotification, userInfo: userInfo)
    }
    
    //TODO: [Review] May be shortcuted to 'postKBShowNotification' (unnecessary)
    func postKeyboardDidHideNotification(userInfo: [AnyHashable : Any]? = nil) {
        post(name: UIResponder.keyboardDidHideNotification, userInfo: userInfo)
    }
}
//TODO: [Review] Redurant row


struct UIViewControllerAlertItems {
    var title: String?
    var message: String?
    var button: String
}

//TODO: [Review] Names of custom types shouldn't has prefix `UI`. Exceptions - names for test cases
//TODO: [Review] Rename it to values pair ot smtg like dat
struct UIViewControllerNotificationItems {
    //TODO: [Review] Redurant empty row
    
    static let allItems = getItems(with: 434, -57, 0)
    
    let first: CGFloat
    let second: CGFloat
    
    //TODO: [Review] Rename to all pairs combinations or ...
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


class NotifiableViewController: UIViewController {
    //TODO: [Review] Redurant empty row
    
    static let defaultKeyboardHight: CGFloat = -10
    
    var isNotified = false
    var keyboardHeight = NotifiableViewController.defaultKeyboardHight
    
    override func kbDidChangeHeightTo(_ height: CGFloat) {
        isNotified = true
        keyboardHeight = height
        super.kbDidChangeHeightTo(height)
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
        //TODO: [Review] Why not `unregisterFromKBNotifications`?
        NotificationCenter.default.removeObserver(self)
    }
    
    func reset() {
        isNotified = false
        keyboardHeight = NotifiableViewController.defaultKeyboardHight
    }
    
}
