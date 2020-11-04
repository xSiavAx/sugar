import Foundation

//TODO: Move This and Related classed classes to SSSugar.

/// Requirements for Coding Dict owner.
public protocol SSKeyStoringOwner: AnyObject {
    var storage: SSKeyFieldStorage {get set}
}

/// Property wrapper to process (write and parse) Key Storage based on some `KeyField`.
///
/// - Important: `owner` should be assigned after property initialization.
///
/// See `KeyField` for more info.
@propertyWrapper
public struct SSKeyStoring<T> {
    /// Shortcut for `KeyField<T>` type
    public typealias Field = SSKeyField<T>
    
    /// Storage owner. Should be injected after property initialization via `_propName = some`. Usually storage owner is also property owner.
    /// On did set writes default value to storage if needed.
    public weak var owner: SSKeyStoringOwner? {
        didSet {
            if (owner != nil && writeDefault) {
                field.writeDefaultIfNeeded(to: &owner!.storage)
            }
        }
    }
    /// Field to parse/write to storage by.
    public var field: Field
    
    /// Indicates should default value be written to storage on owner set or not.
    public let writeDefault: Bool
    
    /// Wrapped value.
    /// Accessor and mutator using `field` and `owner`'s `storage` to provides their logic.
    public var wrappedValue: T {
        get { field.parse(owner!.storage) }
        set { field.write(to: &owner!.storage, val: newValue) }
    }
    
    /// Creates new wrapper with type based on property type, with title and default value of field and with write on start logic based on passed params.
    /// - Parameter name: Title of field.
    /// - Parameter defaultValue: Default value that used on storage has no value for passed key (title).
    /// - Parameter writeOnStart: Indicates should default value be written to storage on owner set or not.
    /// - Parameter adapter: `KeyField` value adapter
    public init(_ name: String, _ defaultValue: T, writeOnStart: Bool = false, adapter:Field.Adapter? = nil) {
        field = SSKeyField(name, defaultValue, adapter: adapter)
        writeDefault = writeOnStart
    }
    
    /// Creates new wrapper with type based on property type, with title of field and write on start logic based on passed params.
    /// - Parameter name: Title of field.
    /// - Parameter adapter: `KeyField` value adapter
    public init(_ name: String, adapter: Field.Adapter? = nil) {
        field = SSKeyField(name, adapter: adapter)
        writeDefault = false
    }
}
