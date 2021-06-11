import Foundation

extension HTTPURLResponse: SSResponseAdditionData {
    public func headerValue(for key: String) -> String? {
        if #available(iOS 13, *) {
            return value(forHTTPHeaderField: key)
        }
        return allHeaderFields[key] as? String
    }
}
