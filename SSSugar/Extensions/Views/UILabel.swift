import Foundation

extension UILabel {
    /// Ask view to calculate it's possible size best fits the specified size.
    ///
    ///  If label has content, it works as usual sizeThatFits, otherwise it works like sizeThatFits for label with space symbol as it's content (' ').
    ///
    /// - Parameter size: Size to fit.
    /// - Returns: Possible size to fit passed one.
    public func nonEmptySizeThatFits(_ size: CGSize) -> CGSize {
        if let mText = text {
            if (mText.count > 0) {
                return sizeThatFits(size)
            }
        }
        return sizeThatFits(size, withText: " ")
    }
    
    /// Ask view to calculate it's estimmated (for passed text) size best fits the specified size.
    ///
    ///  It works like regular sizeThatFits for label with passed `text` as it's content (' ').
    /// - Parameters:
    ///   - size: Size to fit.
    ///   - withText: Text to mesure
    /// - Returns: Estimmated size to fit passed one.
    public func sizeThatFits(_ size: CGSize, withText: String) -> CGSize {
        return withText.size(withAttributes: [.font: font!])
    }
    
    //MARK: - Deprecated
    
    ///**Deprecated**. Renamed to `nonEmptySizeThatFits`.
    public func possibleSizeThatFits(_ size: CGSize) -> CGSize {
        return nonEmptySizeThatFits(size)
    }
}
