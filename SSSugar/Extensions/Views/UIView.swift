#if !os(macOS)
import UIKit

public extension UIView {
    var safeFrame: CGRect {
        if #available(iOS 11, *) {
            return bounds.inset(by: safeAreaInsets)
        }
        return bounds
    }
    
    static var defaultAnimationDuration: TimeInterval { 0.25 }
    var defaultAnimationDuration: TimeInterval { Self.defaultAnimationDuration }
    
    func addSubviews(_ subviews : UIView...) {
        subviews.forEach { (subview) in
            addSubview(subview)
        }
    }
    
    func add(subviews : [UIView]) {
        subviews.forEach { (subview) in
            addSubview(subview)
        }
    }
    
    func hasParent(_ needle: UIView) -> Bool {
        var view = self
        
        while let sView = view.superview {
            if (sView === needle) {
                return true
            }
            view = sView
        }
        return false
    }
}

//MARK: - deprecated
extension UIView {
    ///**Deprecated**. Use `addSubviews(_ subviews : UIView...)` instead.
    @available(*, deprecated, message: "Use addSubviews(_ subviews : UIView...) instead")
    func addSubviews(_ subviews : [UIView]) {
        subviews.forEach { (subview) in
            addSubview(subview)
        }
    }
}
#endif
