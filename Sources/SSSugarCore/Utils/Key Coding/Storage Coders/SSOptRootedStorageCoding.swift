import Foundation

/// Sortcut for Json object Dict field type.
public typealias SSKeyFieldOptObj = SSKeyField<[String : Any]?>

/// Requirements for any Storage Coding that know's it's root Field but may be not presented in passed dict
///
/// #Extension:
/// For `DictCoder` declared initialization and writing.
public protocol SSOptRootedStorageCoding {
    static var root: SSKeyFieldOptObj {get}
}

extension SSOptRootedStorageCoding where Self: SSStorageCoder {
    /// Creates new Coder with dict parsed from passed one.
    /// - Parameter dict: Dict to parse initialization dict.
    public init?(parse dict: [String : Any]) {
        guard let dict = Self.root.parse(dict) else {
            return nil
        }
        self.init(dict: dict)
    }
    
    /// Writes dict (representing storage) to passed one.
    /// - Parameter other: Dict to write to.
    public func wtite(to other: inout SSKeyFieldStorage) {
        Self.root.write(to: &other, val: dict())
    }
}

