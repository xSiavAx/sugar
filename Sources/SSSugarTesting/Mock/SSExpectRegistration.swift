import Foundation

public class SSExpectRegistration {
    public var id: String
    public var label: String?
    public var result: Any
    public var args: SSMockCallArgs = SSMockCallArgs()
    public var call: SSMockCallExpectation!
    
    public init(result: Any, label: String?, id: String = UUID().uuidString) {
        self.result = result
        self.label = label
        self.id = id
    }

    @discardableResult
    public func initCallExp(function: String) -> SSMockCallExpectation {
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

