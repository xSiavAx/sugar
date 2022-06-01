import Foundation
import SSSugarNetwork
import SSSugarCore

open class SSResponseAddonMock: SSResponseAdditionData {
    open var headers: [String : String]
    
    public init(headers: [String : String]) {
        self.headers = headers
    }
    
    open func headerValue(for key: String) -> String? {
        return headerValue(for: key)
    }
}
