import Foundation

open class SSMock: SSMocking {
    open var calls = [SSMockCallExpectation]()
    open var registration: SSExpectRegistration!
    open var onFail: (String?) -> Void
    
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
