import Foundation
import CoreGraphics

public extension CGSize {
    /// Returns size that are union of subject size and passed one.
    ///
    /// - Warning: Method doesn't return sum of sizes but union.
    /// ```
    /// let unitedSize = CGSize(width:100, height:50).united(with:CGSize(width:25, height:75)) //(100, 75)
    /// ```
    /// - Parameter size: size to union with.
    /// - Returns: Size with maximized width and height.
    func united(with size: CGSize) -> CGSize {
        return CGSize(width:max(width, size.width), height:max(height, size.height))
    }
    
    func extended(by size: CGSize) -> CGSize {
        return extended(dx: size.width, dy: size.height)
    }
    
    func extended(dx: CGFloat = 0, dy: CGFloat = 0) -> CGSize {
        return CGSize(width: width + dx, height: height + dy)
    }
    
    func added(to size: CGSize, vertically: Bool = true) -> CGSize {
        if (vertically) {
            return CGSize(width: max(width, size.width), height: height + size.height)
        }
        return CGSize(width: width + size.width, height: max(height, size.height))
    }
    
    /// Returns size that are intersection of subject size and passed one.
    ///
    /// ```
    /// let intersectionSize = CGSize(width:100, height:50).intersected(with:CGSize(width:25, height:75)) //(25, 50)
    /// ```
    /// - Parameter size: size to intersect with.
    /// - Returns: Size with minimized width and height.
    func intersected(with size: CGSize) -> CGSize {
        return CGSize(width:min(width, size.width), height:min(height, size.height))
    }
    
    //MARK: - deprecated
    /// - Warning: **Deprecated**. Use `united(with:)` instead.
    @available(*, deprecated, message: "Use united(with:) instead")
    func union(with size: CGSize) -> CGSize {
        return united(with: size)
    }
    
    /// - Warning: **Deprecated**. Use `added(to:vertically:)` insted.
    @available(*, deprecated, renamed: "added(to:vertically:)")
    func added(to size: CGSize, vetically: Bool = true) -> CGSize {
        if (vetically) {
            return CGSize(width:max(width, size.width), height:height + size.height)
        }
        return CGSize(width:width + size.width, height:max(height, size.height))
    }
}

//TODO: Add docs

public prefix func -(size: CGSize) -> CGSize {
    return CGSize(width: -size.width, height: -size.height)
}

public func +(lSize: CGSize, rSize: CGSize) -> CGSize {
    return CGSize(width: lSize.width + rSize.width, height: lSize.height + rSize.height)
}

public func -(lSize: CGSize, rSize: CGSize) -> CGSize {
    return lSize + (-rSize)
}
