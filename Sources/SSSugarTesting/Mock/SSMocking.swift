import Foundation

public protocol SSMocking: AnyObject {
    var calls: [SSMockCallExpectation] { get set }
    var registration: SSExpectRegistration! { get set }
    var onFail: (_ message: String?) -> Void { get }
}

public extension SSMocking {
    //MARK: public
    
    func call<T>(_ args: Any?..., function: String = #function) throws -> T {
        return try doCall(args, function: function)
    }
    
    func call(_ args: Any?..., function: String = #function) throws {
        try doCall(args, function: function) as Void
    }
    
    @discardableResult
    func expect(label: String? = nil, job: (Self) throws -> Void) -> SSMockCallExpectation {
        return expect(result: (), label: label, job: job)
    }
    
    @discardableResult
    func expect(label: String? = nil, job: (Self, SSMockCallArgs) throws -> Void) -> SSMockCallExpectation {
        return expect(result: (), label: label, job: job)
    }
    
    @discardableResult
    func expect<T>(result: T, label: String? = nil, job: (Self) throws -> T) -> SSMockCallExpectation {
        return expect(result: result, label: label) { mock, _ in try job(mock) }
    }
    
    @discardableResult
    func expect<T>(result: T, label: String? = nil, job: (Self, SSMockCallArgs) throws -> T) -> SSMockCallExpectation {
        registration = SSExpectRegistration(result: result, label: label)

        let _ = try? job(self, registration.args)
        let call = registration.call!
        
        registration = nil
        return call
    }
    
    func verify() {
        if (!calls.isEmpty) {
            onFail("\(self) epxects calls\n\(calls)")
        }
    }
    
    //MARK: private
    
    private func doCall<T>(_ args: [Any?], function: String) throws -> T {
        if let registration = registration {
            registration.initCallExp(function: function)
            
            calls.append(registration.call)
            
            return registration.result as! T
        }
        guard let expectation = calls.first else {
            let message = "There is no expectation for call `\(function)`"
            onFail(message)
            
            return () as! T //For `Void` cases
        }
        calls.remove(at: 0)
        
        let result: Result<T, SSMockCallExpectation.FailCause> = try expectation.process(function: function, args: args)
        
        switch result {
        case .failure(let cause):
            let message = "Expectation for `\(expectation.id)` has failed.\nCause is \(cause)"
            onFail(message)
            return () as! T //For `Void` cases
        case .success(let ret):
            return ret
        }
    }
}
