import Foundation

/// Requirements for any Storage Coding that know's it's root Field.
///
/// #Extension:
/// For `DictCoder` declared initialization and writing.
public protocol SSRootedStorageCoding {
    static var root: SSKeyFieldObj {get}
}

/// Holder for some Storage. Useless as is and should be used within inheritance as Ancestor. Such inheritors represents some Entity that parses/writes from/to storage.
///
/// Usually inheritors declares some `KeyStoring` fields and setup em via `setup` method (that assigns `self` as filed's `owner`) inside overriden `bindPropOwner` method (that automatically calls at end of init of Ancestor).
///
/// Inheritor will has additional methods (`init(parse:)` and `wtite(to:)`) if it conforms to `RootedStorageCoding`.
///
/// - Important: Inheritor must call `setup` for it's `KeyStoring` properties (usually inside overriden `bindPropOwner`), fatal error will occur otherwise.
///
/// # Conforms to:
/// `ParseCodingOwner`
public class SSStorageCoder: SSKeyStoringOwner {
    public var storage: SSKeyFieldStorage
    
    /// Creates new Coder with passed dict as it's storage.
    /// - Parameter dict: Dict storage.
    public required init(dict mDict: [String : Any] = [:]) {
        storage = mDict
        bindPropOwner()
    }
    
    /// Method for binding `self` as `owner` to `KeyStoring` fields.
    ///
    /// Calls at end of init. Do nothing as is. Inheritors should override this method to setup (via `setup` their fields.
    public func bindPropOwner() {}
    
    /// Set `self` and passed `adapter` as `owner` and `adapter` to passed `KeyStoring` field.
    /// - Parameters:
    ///   - prop: Property to setup.
    public func setup<T>(_ prop: inout KeyStoring<T>) {
        prop.owner = self
    }
    
    /// Creates and returns dictionary based on storage.
    /// - Returns: Storage representing dictionary.
    public func dict() -> [String : Any] {
        return storage as! [String : Any]
    }
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
