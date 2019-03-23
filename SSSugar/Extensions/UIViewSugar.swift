import UIKit

public extension UIView {
    var safeFrame: CGRect {
        return bounds.inset(by: safeAreaInsets)
    }
    
    func addSubviews(_ subviews : [UIView]) {
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
