#if !os(macOS)
import UIKit

open class SSTextField : UITextField {
    public static let kDefaultBorderPadding : CGFloat = 8.0
    public static let kDefaultCornerRadius : CGFloat = 8.0
    private var isBordered = false
    private var borderPadding : CGFloat!
    
    public var chainResponder : UIResponder?
}

extension SSTextField {
    public func addBorder(color : UIColor,
                   padding : CGFloat = kDefaultBorderPadding,
                   radius : CGFloat = kDefaultCornerRadius) {
        
        layer.borderColor   = color.cgColor
        layer.borderWidth   = pixelSize()
        layer.cornerRadius  = radius
        borderPadding       = padding
        isBordered          = true
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: borderPadding, dy: 0)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var finalSize = super.sizeThatFits(size)
        
        if (isBordered) {
            finalSize.height += 2*borderPadding
            finalSize.width += 2*borderPadding
        }
        return finalSize
    }
}
#endif
