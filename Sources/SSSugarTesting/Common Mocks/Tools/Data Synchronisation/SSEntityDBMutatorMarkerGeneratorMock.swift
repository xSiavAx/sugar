import Foundation
import SSSugarCore

open class SSEntityDBMutatorMarkerGeneratorMock: SSMock, SSEntityDBMutatorMarkerGenerator {
    open func newMarker() -> String {
        try! super.call()
    }
    
    @discardableResult
    open func expectNew(marker: String) -> SSMockCallExpectation {
        return expect(result: marker) { $0.newMarker() }
    }
}
