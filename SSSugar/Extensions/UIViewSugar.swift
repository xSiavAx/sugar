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
}
