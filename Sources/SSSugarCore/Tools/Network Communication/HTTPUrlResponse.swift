import Foundation

extension HTTPURLResponse: SSResponseAdditionData {
    public func headerValue(for key: String) -> String? {
        return value(forHTTPHeaderField: key)
    }
}
