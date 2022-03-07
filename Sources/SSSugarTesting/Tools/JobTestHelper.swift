import Foundation
import XCTest

public class JobTestHelper {
    public enum AsssertResult<Result> {
        case dontMatch(expected: Result)
        case fail(String)
        case success
    }
    
    public var setUp: (() -> Void)?
    public var tearDown: (() -> Void)?
    public unowned var test: XCTestCase
    
    public init(test: XCTestCase) {
        self.test = test
    }
    
    @discardableResult
    public func setSetUp(_ setUp: (() -> Void)?) -> Self {
        self.setUp = setUp
        return self
    }
    
    @discardableResult
    public func setTearDown(_ tearDown: (() -> Void)?) -> Self {
        self.tearDown = tearDown
        return self
    }
    
    private func process<R>(assertResult: AsssertResult<R>?, for result: R) {
        switch assertResult {
        case .dontMatch(let expected):
            XCTFail("Result doesn't match expected.\n\(result)\n\(expected)")
        case .fail(let message):
            XCTFail(message)
        case .none, .success:
            break
        }
    }
    
    private func assertWith<Result>(result: Result, expResult: Result, compare: (Result, Result) -> Bool) -> AsssertResult<Result> {
        if (compare(expResult, result)) {
            return .success
        }
        return .dontMatch(expected: expResult)
    }
}

//Sync job

public extension JobTestHelper {
    func doesThrow<Result>(error: Error, job: () throws -> Result) {
        setUp?()
        XCTAssertThrowsError(try job(), "Expected error \(error) hasn't thrown") { XCTAssertTrue($0.reflectingEqualTo(other: error), "Job has thrown \($0) that isn't as expected \(error)") }
        tearDown?()
    }
    
    func nonThrows<Result>(job: () throws -> Result) -> Result {
        return checkAndAssert(job: job)
    }
    
    func nonThrows<Result>(expResult: Result, compare: @escaping (Result, Result) -> Bool, job: () throws -> Result) {
        let _ = checkAndAssert(assert: { assertWith(result: $0, expResult: expResult, compare: compare) }, job: job)
    }
    
    func nonThrows<Result: Equatable>(expResult: Result, job: () throws -> Result) {
        nonThrows(expResult: expResult, compare: ==, job: job)
    }
    
    /// Had different signature to avoid ambigouses when Result are Equatable and SSTestComparing at the same time
    func nonThrowsTC<Result: SSTestComparing>(expResult: Result, job: () throws -> Result) {
        nonThrows(expResult: expResult, compare: { $0.testSameAs(other: $1) }, job: job)
    }
    
    private func checkAndAssert<Result>(assert: (Result) -> AsssertResult<Result>? = { _ in nil },
                                        job: () throws -> Result) -> Result {
        setUp?()
        let result = test.nonThrow(job)
        process(assertResult: assert(result), for: result)
        tearDown?()
        return result
    }
}

//Async job

public extension JobTestHelper {
    func checkNoAssert<Result>(job: (@escaping (Result)->Void)->Void) -> Result {
        return check(assert: nil, job: job)
    }
    
    func check<Result>(expResult: Result, compare: @escaping (Result, Result) -> Bool, job: (@escaping (Result)->Void)->Void) {
        let _ = check(assert: { self.assertWith(result: $0, expResult: expResult, compare: compare) }, job: job)
    }
    
    func check<Result: Equatable>(expResult: Result, job: (@escaping (Result)->Void)->Void) {
        check(expResult: expResult, compare: ==, job: job)
    }
    
    func checkTC<Result: SSTestComparing>(expResult: Result, job: (@escaping (Result)->Void)->Void) {
        check(expResult: expResult, compare: { $0.testSameAs(other: $1) }, job: job)
    }
    
    func check(expError: Error? = nil, job: (@escaping (Error?)->Void)->Void) {
        check(expResult: expError, compare: testCompare(loError:roError:), job: job)
    }
    
    private func check<Result>(assert: ((Result) -> AsssertResult<Result>)?, job: (@escaping (Result)->Void)->Void) -> Result {
        var result: Result?
        
        setUp?()
        
        test.wait() { exp in
            job() {
                result = $0
                self.process(assertResult: assert?($0), for: $0)
                exp.fulfill()
            }
        }
        tearDown?()
        
        return result!
    }
}
