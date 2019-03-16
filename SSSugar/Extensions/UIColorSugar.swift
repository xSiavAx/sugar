import UIKit

public extension UIColor {
    convenience init(redV: CGFloat, greenV: CGFloat, blueV: CGFloat, alpha : CGFloat = 1.0) {
        self.init(red:redV/255, green:greenV/255, blue:blueV/255, alpha:alpha)
    }
}
