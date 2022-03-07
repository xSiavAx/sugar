import Foundation
import SSSugarCore

public protocol SSDBColTypeTesting: SSDBColType {
    associatedtype TestResult: SSDBColType & Equatable
    
    func onBind(args: SSMockCallArgs) -> Self
    func onResult() -> TestResult
}

public extension SSDBRawColType where Self: Equatable {
    func onBind(args: SSMockCallArgs) -> Self {
        return args.eq(self)
    }
    
    func onResult() -> Self {
        return self
    }
}

public extension SSDBColTypeBased where BaseCol: SSDBColTypeTesting {
    func onBind(args: SSMockCallArgs) -> Self {
        let _ = baseCol.onBind(args: args)
        return self
    }
    
    func onResult() -> BaseCol {
        return baseCol
    }
}

extension Int: SSDBColTypeTesting {}
extension Int64: SSDBColTypeTesting {}
extension Double: SSDBColTypeTesting {}
extension String: SSDBColTypeTesting {}
extension Data: SSDBColTypeTesting {}
extension Bool: SSDBColTypeTesting {}
extension Date: SSDBColTypeTesting {}

extension Optional: SSDBColTypeTesting where Wrapped: SSDBColTypeTesting & Equatable {
    public typealias TestResult = Self
    
    public func onBind(args: SSMockCallArgs) -> Self {
        switch self {
        case .some(let val):
            return val.onBind(args: args)
        case .none:
            return self
        }
    }
    
    public func onResult() -> Self {
        return self
    }
}
