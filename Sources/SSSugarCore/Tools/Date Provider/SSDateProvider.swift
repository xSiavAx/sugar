import Foundation
import CoreVideo

public protocol SSDateBuilding {
    /// Returns date based on passed ts (offset from epoch start)
    func date(ts: Int) -> Date
    /// Returns date based on passed interval (offset from epoch start)
    func date(interval: TimeInterval) -> Date
    /// Returns date based on passed interval and start date (offset from passed date)
    func date(interval: TimeInterval, since: Date) -> Date
}

public protocol SSDateProviding {
    /// Returns current time
    func current() -> Date
    /// Returns current with passed interval as offset
    func currentWith(interval: TimeInterval) -> Date
}

/// Default implementations for `SSDateBuilding` and `SSDateProviding`
///
/// Tool uses regular `Date` initializers to build and provide dates 
public class SSDateProvider: SSDateProviding, SSDateBuilding {
    public init() {}
    
    public func current() -> Date {
        return .init()
    }
    
    public func date(ts: Int) -> Date {
        return .init(ts: ts)
    }
    
    public func date(interval: TimeInterval) -> Date {
        return .init(timeIntervalSince1970: interval)
    }
    
    public func date(interval: TimeInterval, since date: Date) -> Date {
        return .init(timeInterval: interval, since: date)
    }
    
    public func currentWith(interval: TimeInterval) -> Date {
        return .init(timeIntervalSinceNow: interval)
    }
}
