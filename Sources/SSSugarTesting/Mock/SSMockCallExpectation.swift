import Foundation
import SSSugarCore

public class SSMockCallExpectation: CustomStringConvertible {
    public enum FailCause: Error {
        case invalidFunction(String)
        case invalidArgs(String)
        case invalidReturnType
    }
    public var id: String
    public var function: String
    public var mockArgs: SSMockCallArgs
    public var result: Any?
    public var error: Error?
    public var onReturn: (() -> Any?)?
    public var jobs = [()->Void]()
    public var asyncJobs = [()->Void]()
    public var futures = [()->Void]()
    
    public var description: String { return id }

    public init(id: String, function: String, mockArgs: SSMockCallArgs, result: Any?) {
        self.id = id
        self.function = function
        self.mockArgs = mockArgs
        self.result = result
    }
    
    //MARK: - public
    
    public func process<T>(function mFunction: String, args: [Any?]) throws -> Result<T, FailCause> {
        if let cause = check(function: mFunction) ?? check(args:args) {
            return .failure(cause)
        }
        
        doJobs()
        doAsyncJobs()
        try throwErrorIfNeeded()
        
        guard let ret = retValue() as? T else {
            return .failure(.invalidReturnType)
        }
        return .success(ret)
    }
    
    @discardableResult
    public func andReturn(_ mOnReturn: @escaping () -> Any?) -> SSMockCallExpectation {
        onReturn = mOnReturn
        return self
    }
    
    @discardableResult
    public func andDo(_ job: @escaping () -> Void) -> SSMockCallExpectation {
        jobs.append(job)
        return self
    }
    
    @discardableResult
    public func andAsync(executor: SSExecutor = DispatchQueue.bg, _ job: @escaping () -> Void) -> SSMockCallExpectation {
        asyncJobs.append { executor.execute(job) }
        return self
    }
    
    @discardableResult
    public func andThrow(_ mError: Error) -> SSMockCallExpectation {
        error = mError
        return self
    }
    
    @discardableResult
    public func andFuture(_ job: @escaping () -> Void) -> SSMockCallExpectation {
        futures.append(job)
        return self
    }
    
    @discardableResult
    public func doFutures() -> SSMockCallExpectation {
        futures.forEach() { $0() }
        return self
    }
    
    @discardableResult
    public func andAsyncFutures(executor: SSExecutor = DispatchQueue.bg) -> SSMockCallExpectation {
        andAsync(executor: executor) {[weak self] in self?.doFutures() }
    }
    
    //MARK: - private
    
    private func check(function mFunction: String) -> FailCause? {
        if (function != mFunction) {
            return .invalidFunction("Expects \(function)\nGot\n\(mFunction)")
        }
        return nil
    }
    
    private func check(args: [Any?]) -> FailCause? {
        if let error = mockArgs.verify(args: args) {
            return .invalidArgs(error.description)
        }
        return nil
    }
    
    private func doJobs() {
        jobs.forEach() { $0() }
    }
    
    private func doAsyncJobs() {
        asyncJobs.forEach() { $0() }
    }
    
    private func throwErrorIfNeeded() throws {
        if let error = error {
            throw error
        }
    }
    
    private func retValue() -> Any? {
        if let onReturn = onReturn { return onReturn() }
        return result
    }
}
