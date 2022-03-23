import Foundation

/// Don't use it directly. Use `ValueCaptor` or `ValueShortCaptor` instead
open class SSBaseValueCaptor<Value> {
    public let dummy: Value
    private var value: Value!
    open var hasValue: Bool { value != nil }
    
    public init(dummy: Value) {
        self.dummy = dummy
    }
        
    open func capture(value: Value) {
        self.value = value
    }
    
    open func protValue() -> Value {
        return value
    }
    
    open func resetValue() {
        value = nil
    }
}
