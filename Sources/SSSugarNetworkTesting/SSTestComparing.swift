import SSSugarTesting
import SSSugarNetwork
import Foundation

extension SSApiResponse: SSTestComparing where Entity: SSTestComparing {
    public func testSameAs(other: SSApiResponse<Entity, CommonError, SpecificError>) -> Bool {
        switch (self, other) {
        case (.success(let entity), .success(let oEntity)):
            return entity.testSameAs(other: oEntity)
        case (.fail(let error), .fail(let expError)):
            return error.reflectingEqualTo(other: expError)
        case (.success(_), .fail(_)), (.fail(_), .success(_)):
            return false
        }
    }
}

extension SSApiCallOptions: SSTestComparing {
    public func testSameAs(other: SSApiCallOptions) -> Bool {
        self.baseURL == other.baseURL &&
        self.headers == other.headers &&
        type(of: self.argsConverter) == type(of: other.argsConverter)
    }
}
