import Foundation

extension KeyedEncodingContainer {
    public mutating func e<T: Encodable>(_ val: T, _ key: Key) throws {
        try encode(val, forKey: key)
    }
}
