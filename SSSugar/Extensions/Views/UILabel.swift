import Foundation

extension UILabel {
    /// Ask view to calculate possible it's possible size best fits the specified size.
    ///
    ///  If label has content, it works as usual sizeThatFits, otherwise it works like sizeThatFits for label with space symbol as it's content (' ').
    ///
    /// - Parameter size: Size to fit.
    /// - Returns: Possible size to fit passed one.
    public func possibleSizeThatFits(_ size: CGSize) -> CGSize {
        if let mText = text {
            if (mText.count > 0) {
                return sizeThatFits(size)
            }
        }
        return " ".size(withAttributes: [.font: font!])
    }
}
