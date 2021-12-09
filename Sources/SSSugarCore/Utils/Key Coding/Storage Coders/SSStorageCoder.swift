import Foundation

/// Holder for some Storage. Useless as is and should be used within inheritance as Ancestor. Such inheritors represents some Entity that parses/writes from/to storage.
///
/// Usually inheritors declares some `SSKeyStoring` fields and setup em via `setup` method (that assigns `self` as filed's `owner`) inside overriden `bindPropOwner` method (that automatically calls at end of init of Ancestor).
///
/// Inheritor will has additional methods (`init(parse:)` and `wtite(to:)`) if it conforms to `RootedStorageCoding`.
///
/// - Important: Inheritor must call `setup` for it's `SSKeyStoring` properties (usually inside overriden `bindPropOwner`), fatal error will occur otherwise.
///
/// # Conforms to:
/// `ParseCodingOwner`
open class SSStorageCoder: SSKeyStoringOwner {
    public var storage: SSKeyFieldStorage
    
    /// Creates new Coder with passed dict as it's storage.
    /// - Parameter dict: Dict storage.
    public required init(dict mDict: [String : Any] = [:]) {
        storage = mDict
        bindPropOwner()
    }
    
    /// Method for binding `self` as `owner` to `SSKeyStoring` fields.
    ///
    /// Calls at end of init. Do nothing as is. Inheritors should override this method to setup (via `setup` their fields.
    open func bindPropOwner() {}
    
    /// Set `self` and passed `adapter` as `owner` and `adapter` to passed `SSKeyStoring` field.
    /// - Parameters:
    ///   - prop: Property to setup.
    public func setup<T>(_ prop: inout SSKeyStoring<T>) {
        prop.owner = self
    }
    
    /// Creates and returns dictionary based on storage.
    /// - Returns: Storage representing dictionary.
    public func dict() -> [String : Any] {
        return storage as! [String : Any]
    }
}
