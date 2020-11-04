import Foundation

/// Class wrapper that makes variable synchronised (thread safe).
/// - Usage:
/// `````
/// let x = Atomic<Int>(0)
///
/// x.mutate { $0 += 1 }
///
/// `````
/// - Warning:
/// There is no sense to override setter and make it synchronised, cuz a lot of mutating operations use both getter and setter ( += 1 for example) and this operations will not be thread safe.
public class SSAtomic<T> {
    private let queue = DispatchQueue(label: "ss_queue_for_synced_vars")
    private var val: T
    public var value: T { get { return queue.sync {val} } }
    
    public init(_ mVal: T) {
        val = mVal
    }
    
    public func mutate(_ block: (inout T) -> ()) {
        queue.sync { block(&val) }
    }
}
