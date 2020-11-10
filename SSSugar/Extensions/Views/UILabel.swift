#if !os(macOS)
import UIKit

extension UILabel {
    /// Ask view to calculate it's possible size best fits the specified size.
    ///
    /// If label has content, it works as usual `sizeThatFits(_:)`, otherwise it works like `sizeThatFits(_:)` for label with space symbol as it's content (' ').
    ///
    /// - Parameter size: Size to fit.
    /// - Returns: Possible size fits passed one.
    public func nonEmptySizeThatFits(_ size: CGSize) -> CGSize {
        if let text = text, (text.count > 0) {
            return sizeThatFits(size)
        }
        return sizeThatFits(size, withText: " ")
    }
    
    /// Ask view to calculate it's max possible (like it has max number of lines content) and regular size best fit the specified size.
    ///
    /// - Warning: If label's `numberOfLines` is equal to `0`, method will return regular size as `max` component.
    /// - Parameter size: Size to fit.
    /// - Returns: Tuple with actual size and max possible size to fit passed one.
    public func maxSizeThatFits(_ size: CGSize) -> (real:CGSize, max:CGSize) {
        let size = sizeThatFits(size)
        
        if (numberOfLines != 0) {
            let text = Array(repeating: " ", count: numberOfLines).joined(separator: "\n")
            let fitsHeight = sizeThatFits(size, withText: text).height
            
            return (size, CGSize(width: size.width, height: max(fitsHeight, size.height)))
        }
        return (size, size)
    }

    /// Ask view to calculate it's estimated (for passed text) size best fits the specified size.
    ///
    /// It works like regular `sizeThatFits(_:)` for label with passed `text` as it's content with the `numberOfLines` parameter equal to `0`.
    ///
    /// - Parameters:
    ///   - size: Size to fit.
    ///   - withText: Text to mesure
    /// - Returns: Estimated size fits passed one.
    public func sizeThatFits(_ size: CGSize, withText: String) -> CGSize {
        let calculateLabel = UILabel()

        calculateLabel.font = font
        calculateLabel.text = withText
        calculateLabel.numberOfLines = 0

        return calculateLabel.sizeThatFits(size)
    }
    
    //MARK: - Deprecated

    /// # Deprecated
    /// Renamed to the `nonEmptySizeThatFits(_:)`.
    @available(*, deprecated, renamed: "nonEmptySizeThatFits(_:)")
    public func possibleSizeThatFits(_ size: CGSize) -> CGSize {
        return nonEmptySizeThatFits(size)
    }
}
#endif

