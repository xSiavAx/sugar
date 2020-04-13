#if !os(macOS)
import UIKit

extension UILabel {
    /// Ask view to calculate it's possible size best fits the specified size.
    ///
    /// If label has content, it works as usual sizeThatFits, otherwise it works like sizeThatFits for label with space symbol as it's content (' ').
    ///
    /// - Parameter size: Size to fit.
    /// - Returns: Possible size fits passed one.
    public func nonEmptySizeThatFits(_ size: CGSize) -> CGSize {
        if let mText = text {
            if (mText.count > 0) {
                return sizeThatFits(size)
            }
        }
        return sizeThatFits(size, withText: " ")
    }
    
    /// Ask view to calculate it's max possible (like it has max number of lines content) and regular size best fit the specified size.
    ///
    /// - Warning:
    /// If label's `numberOfLines` is equal to 0, method will return regular size as `max` component
    ///
    /// - Parameters:
    ///   - size: Size to fit.
    /// - Returns: Tuple with actual size and max possible size to fit passed one.
    public func maxSizeThatFits(_ size: CGSize) -> (real:CGSize, max:CGSize) {
        let size = sizeThatFits(size)
        
        if (numberOfLines != 0) {
            let text = Array(repeating: " ", count: numberOfLines).joined(separator: "\n")
            let receivedHeight = sizeThatFits(size, withText: text).height
            let maxHeight = receivedHeight > size.height ? receivedHeight : size.height
            
            return (size, CGSize(width: size.width, height: maxHeight))
        }
        return (size, size)
    }
    
    //TODO: Add tests
    /// Ask view to calculate it's estimmated (for passed text) size best fits the specified size.
    ///
    ///  It works like regular sizeThatFits for label with passed `text` as it's content.
    ///
    /// - Parameters:
    ///   - size: Size to fit.
    ///   - withText: Text to mesure
    /// - Returns: Estimmated size fits passed one.
    public func sizeThatFits(_ size: CGSize, withText: String) -> CGSize {
        return withText.size(withAttributes: [.font: font!])
    }
    
    //MARK: - Deprecated
    
    ///**Deprecated**. Renamed to `nonEmptySizeThatFits`.
    @available(*, deprecated, renamed: "nonEmptySizeThatFits(_:)")
    public func possibleSizeThatFits(_ size: CGSize) -> CGSize {
        return nonEmptySizeThatFits(size)
    }
}
#endif

