import UIKit

public extension CGSize {
    /// Returns size that are union of subject size and passed one.
    ///
    /// - Warning: Method doesn't return sum of sizes but union.
    /// ```
    /// let unitedSize = CGSize(width:100, height:50).united(with:CGSize(width:25, height:75))
    /// ```
    /// - Parameter size: size to union with.
    /// - Returns: Size with maximized width and height.
    func united(with size: CGSize) -> CGSize {
        return CGSize(width:max(width, size.width), height:max(height, size.height))
    }
    
    //TODO: Add intersected
    
    //MARK: - deprecated
    /// - Warning: **Deprecated**. Use `united(with:)` instead.
    @available(*, deprecated, message: "Use united(with:) instead")
    func union(with size: CGSize) -> CGSize {
        return united(with: size)
    }
}
