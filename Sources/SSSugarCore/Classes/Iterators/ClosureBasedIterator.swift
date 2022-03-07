import Foundation

/// Sequence which elements creates via passed closure
///
/// Allows to iterate via closure.
///
/// # Conforms to:
/// `Sequence`, `IteratorProtocol`
public struct ClosureBasedIterator<T>: Sequence, IteratorProtocol {
    public let closure: () -> T?

    public init(closure: @escaping () -> T?) {
        self.closure = closure
    }
    
    public mutating func next() -> T? {
        return closure()
    }
}
