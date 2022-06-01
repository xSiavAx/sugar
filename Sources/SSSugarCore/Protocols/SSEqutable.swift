import Foundation

#warning("Remove me")
// It's unsafe to use operator== on inheritors and causes a lot of problems. If u need Equtable use Value Types.

/// Requirements for `Equtable` that could be implemented with two new methods (instead of operator==).
///
/// # Provides:
/// Default `Equatable` implementation for types confroms `Hashable`.
///
/// Useful for inheritance, cuz methods could be easy overridden.
///
/// # See Also:
/// `SSInheritedEquatble`
public protocol SSEquatable: Equatable {
    func isSameProps(with other: Self) -> Bool
    func isSameType(with other: Self) -> Bool
}

public extension Equatable where Self: Hashable & SSEquatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.isSameType(with: rhs)
            && rhs.isSameType(with: lhs)
            && lhs.hashValue == rhs.hashValue
            && lhs.isSameProps(with: rhs)
    }
}

/// Protocol-extension for inheritors whos ancestor confroms to `SSEquatble`. Ppvodies helpfull methods.
///
/// # Provides:
/// * isAncestorSameType(_:) -> Bool - helper for `isSameType` overrideing.
/// * cast(_:, check:) -> Bool - helper for `isSameProps` overrideing.
public protocol SSInheritedEquatable: SSEquatable {
    #warning("TODO")
    //TODO: Remove Ancestor typealias. Use function generic or Any instead; or remove methods at all.
    //Cuz user just forget to declare this typealias in inheritors
    associatedtype Ancestor: SSEquatable
}

public extension SSInheritedEquatable {
    /// Indicates is passed ancestor has same type or not
    /// - Parameter ancestor: Ancestor object to check
    ///
    /// Usefult for `isSameType` overriding.
    func isAncestorSameType(_ ancestor: Ancestor) -> Bool {
        return ancestor as? Self != nil
    }
    
    /// Tries cast passed ancestor to Self Type (return false otherwise), passes it to check closure and returns check result.
    /// - Parameters:
    ///   - ancestor: Ancestor to cast and check
    ///   - check: Check closure to compare properties
    ///
    /// Usefult for `isSameProps` overriding.
    func cast(_ ancestor: Ancestor, check:(_ other: Self)->Bool) -> Bool {
        if let other = ancestor as? Self {
            return check(other)
        }
        return false
    }
}

