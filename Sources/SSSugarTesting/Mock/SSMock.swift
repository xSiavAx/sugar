import Foundation

open class SSMock: SSMocking {
    public var calls = [SSMockCallExpectation]()
    public var registration: SSExpectRegistration!
    public var onFail: (String?) -> Void
    
    public init(onFail: @escaping (String?) -> Void) {
        self.onFail = onFail
    }
}

#if canImport(XCTest)
import XCTest

public extension SSMock {
    convenience init() {
        self.init() { XCTFail($0 ?? "") }
    }
}

#endif
