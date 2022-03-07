import Foundation

/// Sequence which elements creates via passed closure and some stored value
///
/// Allows to iterate via closure with some stored param.
///
/// # Conforms to:
/// `Sequence`, `IteratorProtocol`
public struct ValueBasedIterator<T>: Sequence, IteratorProtocol {
    public private(set) var value: T?
    public let onChange: (T?) -> T?

    public init(first: T?, onChange: @escaping (T?) -> T?) {
        self.value = first
        self.onChange = onChange
    }
    
    public mutating func next() -> T? {
        defer { value = onChange(value) }
        return value
    }
}
