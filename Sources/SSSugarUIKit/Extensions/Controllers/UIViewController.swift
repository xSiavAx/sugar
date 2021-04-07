import UIKit
import SSSugarCore

//MARK: - Alerts
extension UIViewController {
    
    /// Shortcut for presenting `UIAlertController` with given title, message and close button title. Method will execute closure on close if corresponding arg will be provided.
    ///
    /// - Parameters:
    ///   - title: Title for alert view
    ///   - message: Message for alert view
    ///   - btnTitle: Title for alert's action button. Default value is `"Ok"`
    ///   - onSbmt: Code that will be executed on close button tap
    ///
    /// - Important: Both `title` and `message` can't be nil same time
    public func showAlert(title: String? = nil,
                          message: String? = nil,
                          btnTitle: String = "Ok",
                          onSbmt: (() -> Void)? = nil) {
        guard title != nil || message != nil else {
            fatalError("Both title and message can't be nil same time")
        }
        let avc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var handler : ((UIAlertAction)->Void)?
        
        if let cOnSbmt = onSbmt {
            handler = { (action) in cOnSbmt() }
        }
        
        avc.addAction(UIAlertAction(title: btnTitle, style: .default, handler:handler))
        
        self.present(avc, animated: true, completion: nil)
    }
    
    /// Shortcut for presenting `UIAlertController` with Error title. See showAlert(title: message: btnTitle: onSbmt:) for more info.
    ///
    /// - Parameters:
    ///   - message: Message for alert view
    ///   - btnTitle: Title for alert's action button. Default value is `"Ok"`
    ///   - onSbmt: Code that will be executed on close button tap
    public func showErrorAlert(message: String,
                               btnTitle: String = "Ok",
                               onSbmt: (() -> Void)? = nil) {
        showAlert(title: NSLocalizedString("Error"),
                  message: message,
                  btnTitle: btnTitle,
                  onSbmt:onSbmt)
    }
    
    /// Shortcut for presenting `UIAlertController` with Warning title. See showAlert(title: message: btnTitle: onSbmt:) for more info.
    ///
    /// - Parameters:
    ///   - message: Message for alert view
    ///   - btnTitle: Title for alert's action button. Default value is `"Ok"`
    ///   - onSbmt: Code that will be executed on close button tap
    public func showWarningAlert(message: String,
                                 btnTitle: String = "Ok",
                                 onSbmt: (() -> Void)? = nil) {
        showAlert(title: NSLocalizedString("Warning"),
                  message: message,
                  btnTitle: btnTitle,
                  onSbmt:onSbmt)
    }
}

//MARK: - Keyboard
extension UIViewController {
    /// Register controller for Keyboard Notifications. Use it to recieve kbDidChangeHeightTo(:) callbacks.
    /// - Note: Usually you have to call this method inside `init` or `loadView`.
    /// - Important: Don't forget call `unregisterFromKBNotifications()` somewhere. See it's documentation for more info.
    public func registerForKBNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.kbDidShow),
            name: UIResponder.keyboardDidShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.kbDidHide),
            name: UIResponder.keyboardDidHideNotification,
            object: nil)
    }
    
    /// Unregister controller from Keyboard Notifications. Use it if you have used `registerForKBNotifications()`
    /// - Note: Usually you have to call this method inside deinit.
    public func unregisterFromKBNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    /// Method that calls on Keyboard chnaged it's height (incliuding it's appearance/disappearance). Override it to manage anything based on Keyboard height.
    ///
    /// - Parameter height: new keyboard height
    @objc open func kbDidChangeHeightTo(_ height : CGFloat) {
        
    }
    
    @objc private func kbDidShow(notification : Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            kbDidChangeHeightTo(keyboardFrame.cgRectValue.height)
        }
    }
    
    @objc private func kbDidHide(notification : Notification) {
        kbDidChangeHeightTo(0)
    }
}

//MARK: - Controllers relations
extension UIViewController {
    /// Dismiss presented controller if subject controller has one. Otherwise do nothing. Complition will be called anyway.
    /// - Note: Default SDK's `dissmiss(animated: copmplition:)` will dimsmiss subject controller if it has no presented controller. This method will not.
    ///
    /// - Parameters:
    ///   - animated: Do transition animated or not. Default value is false
    ///   - onFinish: Complision handler
    public func dismissPresented(animated: Bool = false, onFinish: (() -> Void)?) {
        if (presentedViewController != nil) {
            dismiss(animated: animated, completion: onFinish)
        } else {
            DispatchQueue.main.async {
                if let mOnFinish = onFinish {
                    mOnFinish()
                }
            }
        }
    }
    
    /// Find and return Root View Controller in controllers hierarchy. Usually it's current window's root view controller.
    ///
    /// - Note: Method will return subject controller if it have no parent controller.
    ///
    /// - Returns: Root View Controller
    public func rootController() -> UIViewController {
        var root = self
        
        while let mParent = root.parent {
            root = mParent
        }
        return root
    }
    
    //MARK: - deprecated
    /// See `dismissPresented(animated:, onFinish:)`
    /// - Important: **Deprecated**. For versions greater then 1.1.0
    @available(*, deprecated, message: "Use inset(toWidth:toHeight:) instead")
    public func dismissAll(animated: Bool = true, onFinish: (() -> Void)?) {
        self.dismissPresented(animated: animated, onFinish: onFinish)
    }
}
