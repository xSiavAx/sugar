import Foundation
import SSSugarCore

public class SSDateProviderMock: SSMock, SSDateBuilding, SSDateProviding {
    //MARK: - SSDateBuilding
    
    public func date(ts: Int) -> Date {
        try! super.call(ts)
    }
    
    public func date(interval: TimeInterval) -> Date {
        try! super.call(interval)
    }
    
    public func date(interval: TimeInterval, since: Date) -> Date {
        try! super.call(interval, since)
    }
    
    //MARK: - SSDateProviding
    
    public func current() -> Date {
        try! super.call()
    }
    
    public func currentWith(interval: TimeInterval) -> Date {
        try! super.call(interval)
    }
    
    //MARK: - public
    
    @discardableResult
    public func expect(current: Date) -> SSMockCallExpectation {
        return expect(result: current) { mock, _ in mock.current() }
    }
    
    @discardableResult
    public func expect(current: Date, interval: TimeInterval) -> SSMockCallExpectation {
        return expect(result: current) { $0.currentWith(interval: $1.eq(interval)) }
    }
}
