import Foundation

/// - Warning: **Deprecated**. Use `init(size:buildBlock:)` instead.
@available(*, deprecated, message: "Use `SSMock` instead")
public class TestQueue {
    public static let defaultQueueValue = "testing_queue_val"
    
    public class Checker {
        private let queue: DispatchQueue
        let value: String
        let key: DispatchSpecificKey<String>? = DispatchSpecificKey()
        
        public init(queue mQueue: DispatchQueue, value mValue: String = defaultQueueValue) {
            queue = mQueue
            value = mValue
            queue.setSpecific(key: key!, value: value)
        }
        
        deinit {
            if let _ = key {
                finilize()
            }
        }
        
        public func isCurrent() -> Bool {
            return DispatchQueue.getSpecific(key: key!) == value
        }
        
        public func finilize() {
            queue.setSpecific(key: key!, value: nil)
        }
    }
    
    public let queue: DispatchQueue
    public let checker: Checker
    
    public init(label: String = "testing_queue", value: String = defaultQueueValue) {
        queue = DispatchQueue(label: label)
        checker = Checker(queue: queue, value: value)
    }

    public func isCurrent() -> Bool {
        return checker.isCurrent()
    }
    
    public func finilize() {
        checker.finilize()
    }
}

