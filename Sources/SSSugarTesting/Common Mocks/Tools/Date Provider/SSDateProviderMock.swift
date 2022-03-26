import Foundation
import SSSugarCore

open class SSDateProviderMock: SSMock, SSDateBuilding, SSDateProviding {
    //MARK: - SSDateBuilding
    
    open func date(ts: Int) -> Date {
        try! super.call(ts)
    }
    
    open func date(interval: TimeInterval) -> Date {
        try! super.call(interval)
    }
    
    open func date(interval: TimeInterval, since: Date) -> Date {
        try! super.call(interval, since)
    }
    
    //MARK: - SSDateProviding
    
    open func current() -> Date {
        try! super.call()
    }
    
    open func currentWith(interval: TimeInterval) -> Date {
        try! super.call(interval)
    }
    
    //MARK: - open
    
    @discardableResult
    open func expect(current: Date) -> SSMockCallExpectation {
        return expect(result: current) { mock, _ in mock.current() }
    }
    
    @discardableResult
    open func expect(current: Date, interval: TimeInterval) -> SSMockCallExpectation {
        return expect(result: current) { $0.currentWith(interval: $1.eq(interval)) }
    }
}
