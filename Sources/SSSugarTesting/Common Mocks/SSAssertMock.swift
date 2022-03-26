import Foundation

open class SSAssertMock: SSMock {
    open func report(msg: String) {
        try! super.call(msg)
    }
    
    @discardableResult
    open func expectCall() -> SSMockCallExpectation {
        expect() { $0.report(msg: $1.any("Dummy msg")) }
    }
}
