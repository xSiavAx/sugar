import UIKit

//MARK: - Alerts
public extension UIViewController {
    func showAlert(title: String,
                   message: String,
                   btnTitle: String,
                   onSbmt: (() -> Void)?) {
        let avc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let cOnSbmt = onSbmt {
            avc.addAction(UIAlertAction(title: btnTitle, style: .default, handler: { (action) in
                cOnSbmt()
            }))
        }
        
        self.present(avc, animated: true, completion: nil)
    }
    
    func showErrorAlert(message: String,
                   btnTitle: String,
                   onSbmt: (() -> Void)? = nil) {
        showAlert(title: NSLocalizedString("Error"),
                  message: message,
                  btnTitle: btnTitle,
                  onSbmt:onSbmt)
    }
    
    func showWarningAlert(message: String,
                        btnTitle: String,
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
    func dismissAll(animated: Bool = true, onFinish: (() -> Void)?) {
        if (self.presentedViewController != nil) {
            self.dismiss(animated: animated, completion: onFinish)
        } else {
            if let mOnFinish = onFinish {
                mOnFinish()
            }
        }
    }
    
    func rootController() -> UIViewController {
        var root = self
        
        while let mParent = root.parent {
            root = mParent
        }
        return root
    }
}
