import UIKit

//MARK: - Alerts
extension UIViewController {
    
    /// Shortcut for presenting `UIAlertController` with given title, message and close button title. Method will execute closure on close if corresponding arg will be provided.
    ///
    /// - Parameters:
    ///   - title: Title for alert view
    ///   - message: Message for alert view
    ///   - btnTitle: title for alert's action button, default value is `"Ok"`
    ///   - onSbmt: code that will be executed on button tap
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
    
    /// Shortcut for presenting `UIAlertController` with Error title'. See showAlert(title: message: btnTitle: onSbmt:) for more info.
    ///
    /// - Parameters:
    ///   - message: Message for alert view
    ///   - btnTitle: title for alert's action button, default value is `"Ok"`
    ///   - onSbmt: code that will be executed on button tap
    public func showErrorAlert(message: String,
                               btnTitle: String = "Ok",
                               onSbmt: (() -> Void)? = nil) {
        showAlert(title: NSLocalizedString("Error"),
                  message: message,
                  btnTitle: btnTitle,
                  onSbmt:onSbmt)
    }
    
    /// Shortcut for presenting `UIAlertController` with Warning title'. See showAlert(title: message: btnTitle: onSbmt:) for more info.
    ///
    /// - Parameters:
    ///   - message: Message for alert view
    ///   - btnTitle: title for alert's action button, default value is `"Ok"`
    ///   - onSbmt: code that will be executed on button tap
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
    
    public func unregisterFromKBNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func kbDidShow(notification : Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            kbDidChangeHeightTo(keyboardFrame.cgRectValue.height)
        }
    }
    
    @objc func kbDidHide(notification : Notification) {
        kbDidChangeHeightTo(0)
    }
    
    @objc open func kbDidChangeHeightTo(_ height : CGFloat) {
        
    }
}

//MARK: - Controllers relations
extension UIViewController {
    public func dismissAll(animated: Bool = true, onFinish: (() -> Void)?) {
        if (self.presentedViewController != nil) {
            self.dismiss(animated: animated, completion: onFinish)
        } else {
            if let mOnFinish = onFinish {
                mOnFinish()
            }
        }
    }
    
    /// Find and return Root View Controller in controllers hierarchy. Usually it's current window's root view controller.
    ///
    /// - Returns: Root View Controller
    public func rootController() -> UIViewController {
        var root = self
        
        while let mParent = root.parent {
            root = mParent
        }
        return root
    }
}
