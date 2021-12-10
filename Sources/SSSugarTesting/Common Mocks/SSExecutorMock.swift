import Foundation
import SSSugarCore

public class SSExecutorMock: SSMock, SSExecutor, SSTimeoutExecutor {
    public func execute(_ work: @escaping () -> Void) {
        try! super.call(work)
    }
    
    public func executeAfter(sec: Int, _ work: @escaping () -> Void) {
        try! super.call(sec, work)
    }
    
    public func executeAfter(sec: Double, _ work: @escaping () -> Void) {
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
