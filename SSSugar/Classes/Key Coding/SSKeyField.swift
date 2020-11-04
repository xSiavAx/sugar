import Foundation

/// Model represents `title` and `Type` information of some Storage field and parse/write logic.
public struct SSKeyField<T> {
    /// Holder for blocks that uses by `KeyField` to adapt custom types to storage ones.
    /// Since storage passes to block adapter could create object from several fields or, even, with data that it stored (in case of inheritor extends `Adapater`). Same are true for backwards logic – writting object to storage.
    /// There is converters (See `Converter`, `ErrorConverter`, `ApiConverter`) with predefined adapters creation logic for common cases (like errors and strings, int and date, UUID and string etc.)
    open class Adapter {
        /// Simplified read closure type
        /// - Parameter val: Value from storage to convert to T
        public typealias To = (_ val: Any?)->T
        /// Simplified write closure type
        /// - Parameter val: Value to convert to some (`Any?`) that is going to be saved to storage
        public typealias From = (_ val: T)->Any?
        /// Read closure type
        /// - Parameters:
        ///   - storage: Storage to obtain additional data if needed
        ///   - key: Filed title with which value has parsed from storage
        ///   - parsed: Value from storage to convert to T
        public typealias Read = (_ storage: SSKeyFieldStorage, _ key: String, _ parsed: Any?)->T
        /// Write closure type
        /// - Parameters:
        ///   - storage: Storage to store additional data if needed
        ///   - key: Filed title with which value will be stored to storage
        ///   - val: Value to convert to some (`Any?`) that is going to be saved to storage
        public typealias Write = (_ storage: inout SSKeyFieldStorage, _ key: String, _ val: T)->Any?
        
        /// Read closure
        public var read: Read?
        /// Write closure
        public var write: Write?
        
        /// Creates new Adapter with passed read and write closures
        /// - Parameters:
        ///   - onRead: Read closure, default values is nil
        ///   - onWrite: Write closure, default values is nil
        public init(onRead: Read? = nil, onWrite: Write? = nil) {
            read = onRead
            write = onWrite
        }
        
        /// Creates new Adapter with passed simplified read and write closures
        /// - Parameters:
        ///   - to: Simplified read closure, default values is nil
        ///   - from: Simplified write closure
        /// - Note: `from` parameter has no default value to avoid ambigous call initializer without params (`Adapter()`)
        public convenience init(to: To? = nil, from: From?) {
            let read: Read? = to != nil ? {(storage, key, parsed) in to!(parsed) } : nil
            let write: Write? = from != nil ? {(storage, key, parsed) in from!(parsed) } : nil

            self.init(onRead: read, onWrite: write)
        }
    }
    
    /// Field title (used as Storage key).
    public let title: String
    
    /// Value converting adapter.
    /// If `adapter` is nil, values will write/read to/from storage as is (without converation)
    /// For more info about `Adapter` and predefined common Adapters see `Adapter` docs.
    public var adapter: Adapter?
    
    /// Default value which returns from parse on no corresping value in storage.
    /// If `deffaultValue` is nil, it will not used. Typically default value specifies only for non optional generic types (`T`).
    public var defaultValue: T?
    
    /// Creates new field with passed params.
    /// - Parameters:
    ///   - title: Field's title.
    ///   - defaultValue: Field's default value, default is nil.
    ///   - adapter: Field's adapter, default is nil.
    public init(_ mTitle: String, _ mDefaultValue: T? = nil, adapter mAdapter: Adapter? = nil) {
        title = mTitle
        adapter = mAdapter
        defaultValue = mDefaultValue
    }
    
    /// Parses value from passed storage.
    /// - Parameter source: Storage to parse.
    /// - Returns: Parsed value.
    ///
    /// If adapter and it's `read` closure aren't nil, closure calls to convert parsed value to final one.
    public func parse(_ source: SSKeyFieldStorage) -> T {
        let val = source[title]
        
        if let defaultValue = defaultValue, val == nil {
            return defaultValue
        }
        if let read = adapter?.read {
            return read(source, title, val)
        }
        return val as! T
    }
    
    /// Writes passed value to passed storage.
    /// - Parameters:
    ///   - source: Storage to write to.
    ///   - val: Value to write to storage.
    ///
    /// If adapter and it's `write` closure aren't nil, closure calls to convert passed value to writing one.
    public func write(to source: inout SSKeyFieldStorage, val: T) {
        if let write = adapter?.write {
            source[title] = write(&source, title, val)
        } else {
            switch val {
            case nil as Any?: source[title] = nil
            default: source[title] = val
            }
        }
    }
    
    /// Writes default value to storage if it's not nil and storage doesn't contains some value.
    /// - Parameter source: Storage to write default value to.
    public func writeDefaultIfNeeded(to source: inout SSKeyFieldStorage) {
        if let defVal = defaultValue, source[title] == nil {
            write(to: &source, val: defVal)
        }
    }
}

/// Sortcut for Json object Dict field type.
public typealias SSKeyFieldObj = SSKeyField<[String : Any]>
