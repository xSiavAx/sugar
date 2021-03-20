#if !os(macOS)
import UIKit

public extension UIColor {
    /// Constructor that builds color using RGB components in 0-255 range.
    /// - Important: RGB component's values have be in 0-255 range, but alpha component has be default 0-1 range.
    /// - Note: **Usage example**
    /// ````
    /// let lightGreen  = UIColor(redV:128, greenV:255, blueV: 128)
    /// let lightBlue   = UIColor(redV:0x80, greenV:0x80, blueV: 0xff)
    /// let redA7       = UIColor(redV:255, alpha: 0.7)
    ///
    /// ````
    /// - Remark:
    /// It's usefull when you work with colors in "classic" hex RGB(A) format, like `(128,255,128)` or `0x8080FF`
    ///
    /// - Parameters:
    ///   - redV: Red component. Default value is 0.
    ///   - greenV: Green component. Default value is 0.
    ///   - blueV: Blue component. Default value is 0.
    ///   - alpha: Alpha component. Default value is 1.0
    convenience init(redV: CGFloat = 0, greenV: CGFloat = 0, blueV: CGFloat = 0, alpha: CGFloat = 1.0) {
        self.init(red:redV/255, green:greenV/255, blue:blueV/255, alpha:alpha)
    }
    
    convenience init(red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0) {
        self.init(red:red, green:green, blue:blue, alpha:1.0)
    }
}
#endif
