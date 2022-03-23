import Foundation

open class SSExpectRegistration {
    open var id: String
    open var label: String?
    open var result: Any
    open var args: SSMockCallArgs = SSMockCallArgs()
    open var call: SSMockCallExpectation!
    
    public init(result: Any, label: String?, id: String = UUID().uuidString) {
        self.result = result
        self.label = label
        self.id = id
    }

    @discardableResult
    open func initCallExp(function: String) -> SSMockCallExpectation {
        call = SSMockCallExpectation(id: callIDFor(function: function), function: function, mockArgs: args, result: result)
        return call
    }
    
    //MARK: - private
    
    private func callIDFor(function: String) -> String {
        var components = ["id: \(id)"]
        
        if let label = label {
            components.append("label: \(label)")
        }
        let description = components.joined(separator: "; ")
        return "\(function) [\(description)]"
    }
}

