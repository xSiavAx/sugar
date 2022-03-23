import Foundation

open class SSCallMock: SSMock {
    open func handle<R>() -> R {
        try! super.call()
    }
    
    open func handle<T, R>(_ arg: T) -> R {
        try! super.call(arg)
    }
    
    open func handle<T1, T2, R>(_ a1: T1, _ a2: T2) -> R {
        try! super.call(a1, a2)
    }
    
    @discardableResult
    open func expectCall() -> SSMockCallExpectation {
        expect() { mock, _ in mock.handle() }
    }
    
    @discardableResult
    open func exectCall<TC: SSTestComparing>(_ result: TC) -> SSMockCallExpectation {
        expect() { $0.handle($1.tseq(result)) }
    }
}
