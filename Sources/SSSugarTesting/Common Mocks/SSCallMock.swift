import Foundation

public class SSCallMock: SSMock {
    public func handle<R>() -> R {
        try! super.call()
    }
    
    public func handle<T, R>(_ arg: T) -> R {
        try! super.call(arg)
    }
    
    public func handle<T1, T2, R>(_ a1: T1, _ a2: T2) -> R {
        try! super.call(a1, a2)
    }
    
    @discardableResult
    public func expectCall() -> SSMockCallExpectation {
        expect() { mock, _ in mock.handle() }
    }
    
    @discardableResult
    public func exectCall<TC: SSTestComparing>(_ result: TC) -> SSMockCallExpectation {
        expect() { $0.handle($1.tseq(result)) }
    }
}
