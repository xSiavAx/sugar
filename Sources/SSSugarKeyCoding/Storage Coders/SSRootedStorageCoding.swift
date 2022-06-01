import Foundation

/// Requirements for any Storage Coding that know's it's root Field.
///
/// #Extension:
/// For `DictCoder` declared initialization and writing.
public protocol SSRootedStorageCoding {
    static var root: SSKeyFieldObj {get}
}

extension SSRootedStorageCoding where Self: SSStorageCoder {
    /// Creates new Coder with dict parsed from passed one.
    /// - Parameter dict: Dict to parse initialization dict.
    public init(parse dict: [String : Any]) {
        self.init(dict: Self.root.parse(dict))
    }
    
    /// Writes dict (representing storage) to passed one.
    /// - Parameter other: Dict to write to.
    public func wtite(to other: inout SSKeyFieldStorage) {
        Self.root.write(to: &other, val: dict())
    }
}

