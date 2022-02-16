import Foundation

public class SSAssertMock: SSMock {
    public func report(msg: String) {
        try! super.call(msg)
    }
    
    public func expectCall() {
        expect() { $0.report(msg: $1.any("Dummy msg")) }
    }
}
