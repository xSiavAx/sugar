import Foundation

extension String {
    /// Return localized string using NSLocalizedString with `self` as key
    public func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    /// Return string for plural form based on localized strings.
    public func localized(count: Int, comment: String = "") -> String {
        var simplifiedNumber = abs(count) % 100
        var keyFormat : String
        
        if (simplifiedNumber > 10 && simplifiedNumber < 20) { // 11-19
            keyFormat = "_5"
        } else {
            simplifiedNumber = simplifiedNumber % 10
            
            if (simplifiedNumber >= 5 || simplifiedNumber == 0) { // 0, 5-10
                keyFormat = "_5"
            } else if (simplifiedNumber > 1) { // 2-4
                keyFormat = "_4"
            } else { // 1
                keyFormat = "_1"
            }
        }
        return NSLocalizedString(self + keyFormat, comment: comment)
    }
    
    /// Return string for plural form based on localized strings.
    /// - Warning: **Deprecated**. Use `localized(count:comment:)` instead.
    @available(*, deprecated, message: "Use `localized(count:comment:)` instead")
    public func localizedNumeral(count: Int, comment: String = "") -> String {
        return localized(count: count, comment: comment)
    }
}
