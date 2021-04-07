import Foundation

extension String {
    /// Return localized string using NSLocalizedString with `self` as key
    public func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
