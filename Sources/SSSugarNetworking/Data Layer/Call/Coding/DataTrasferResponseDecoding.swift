import Foundation

public protocol DataTransferResponseDecoding {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

public struct ResponseDecoder: DataTransferResponseDecoding {
    private let decoder = JSONDecoder()
    
    public init(
        keysDecoding: JSONDecoder.KeyDecodingStrategy? = nil,
        dateDecoding: JSONDecoder.DateDecodingStrategy? = nil
    ) {
        if let keysDecoding = keysDecoding {
            decoder.keyDecodingStrategy = keysDecoding
        }
        if let dateDecoding = dateDecoding {
            decoder.dateDecodingStrategy = dateDecoding
        }
    }

    public func decode<T>(_ data: Data) throws -> T where T: Decodable {
        return try decoder.decode(T.self, from: data)
    }
}
