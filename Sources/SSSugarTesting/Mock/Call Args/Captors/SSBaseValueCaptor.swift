import Foundation

/// Don't use it directly. Use `ValueCaptor` or `ValueShortCaptor` instead
public class SSBaseValueCaptor<Value> {
    public let dummy: Value
    private var value: Value!
    public var hasValue: Bool { value != nil }
    
    public init(dummy: Value) {
        self.dummy = dummy
    }
        
    public func capture(value: Value) {
        self.value = value
    }
    
    public func protValue() -> Value {
        return value
    }
    
    public func resetValue() {
        value = nil
    }
}
