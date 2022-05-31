import Foundation
import SSSugarCore
import SSSugarExecutors

open class SSExecutorMock: SSMock, SSExecutor, SSTimeoutExecutor {
    open func execute(_ work: @escaping () -> Void) {
        try! super.call(work)
    }
    
    open func executeAfter(sec: Int, _ work: @escaping () -> Void) {
        try! super.call(sec, work)
    }
    
    open func executeAfter(sec: Double, _ work: @escaping () -> Void) {
        try! super.call(sec, work)
    }
    
    public enum ExpectCaptorStrategy: CustomStringConvertible {
        case async
        case future
        
        public var description: String {
            switch self {
            case .async: return "Async"
            case .future: return "Future"
            }
        }
        
        public func addTo(exp: SSMockCallExpectation, job: @escaping () -> Void) {
            switch self {
            case .async:
                exp.andAsync(job)
            case .future:
                exp.andFuture(job)
            }
        }
    }
}

public extension SSMocking where Self: SSExecutor {
    //MARK: SSExecutor
    
    static func captor() -> SSValueShortCaptor<()->Void> {
        return .forClosure()
    }
    
    func captor() -> SSValueShortCaptor<()->Void> {
        return Self.captor()
    }
    
    @discardableResult
    func expect(captor: SSValueShortCaptor<() -> Void>) -> SSMockCallExpectation {
        return expect() { $0.execute($1.capture(captor)) }
    }
    
    @discardableResult
    func expect(delay: Bool = false) -> SSMockCallExpectation {
        return expect(strategy: delay ? .future : .async)
    }
    
    @discardableResult
    func expect(strategy: SSExecutorMock.ExpectCaptorStrategy = .async) -> SSMockCallExpectation {
        let captor = captor()
        let exp = expect(captor: captor)
        
        strategy.addTo(exp: exp) {
            captor.released()
        }
        
        return exp
    }
    
    @discardableResult
    func expectAndFuture() -> SSMockCallExpectation {
        expect(strategy: .future)
    }
    
    @discardableResult
    func expectAndAsync() -> SSMockCallExpectation {
        expect(strategy: .async)
    }
    
    @discardableResult
    func expectAndAsync(times: Int) -> [SSMockCallExpectation] {
        (0..<times).map() { _ in expectAndAsync() }
    }
}

public extension SSMocking where Self: SSTimeoutExecutor {
    @discardableResult
    func expectAfter(interval: Int, captor: SSValueShortCaptor<() -> Void>) -> SSMockCallExpectation {
        return expectAfter(interval: Double(interval), captor: captor)
    }
    
    @discardableResult
    func expectAfter(interval: Double, captor: SSValueShortCaptor<() -> Void>) -> SSMockCallExpectation {
        return expect() { $0.executeAfter(sec: $1.eq(interval), $1.capture(captor)) }
    }
    
    @discardableResult
    func expectAfter(interval: Double, delay: Bool = false) -> SSMockCallExpectation {
        return expectAfter(interval: interval, strategy: delay ? .future : .async)
    }
    
    @discardableResult
    func expectAfter(interval: Double, strategy: SSExecutorMock.ExpectCaptorStrategy = .async) -> SSMockCallExpectation {
        let captor = captor()
        let exp = expectAfter(interval: interval, captor: captor)
        
        strategy.addTo(exp: exp) {
            captor.released()
        }
        
        return exp
    }
}
