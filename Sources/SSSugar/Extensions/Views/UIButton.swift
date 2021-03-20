#if !os(macOS)
import UIKit

public extension UIButton {
    func setTitle(_ title: String?) {
        self.setTitle(title, for:.normal)
    }
    
    func addTarget(_ target: Any?, action: Selector) {
        self.addTarget(target, action: action, for: .touchUpInside)
    }
}
#endif
