import Foundation

extension KeyedDecodingContainer {
    public func decode<T>(forKey key: Key) throws -> T where T : Decodable {
        try decode(T.self, forKey: key)
    }
    
    public func d<T>(_ key: Key) throws -> T where T : Decodable {
        try decode(T.self, forKey: key)
    }
}

