import Foundation

public protocol DataTransferRequestEncoding {
    func encode<T: Encodable>(_ model: T) throws -> Data
}

public struct URLRequestEncoder: DataTransferRequestEncoding {
    private let encoder = JSONEncoder()

    public init() {}

    public func encode<T: Encodable>(_ model: T) throws -> Data {
        let dictionary = try dictFrom(model: model)
        let urlComponents = urlComponents(dict: dictionary)

        return try dataFromURL(components: urlComponents, model: model)
    }
    
    private func dictFrom<T: Encodable>(model: T) throws -> [String : String] {
        let json = try? JSONSerialization.jsonObject(with: encoder.encode(model))
        guard let dictionary = json as? [String : String] else {
            throw cantCreateDictError(model)
        }
        return dictionary
    }
    
    private func dataFromURL<T>(components: URLComponents, model: T) throws -> Data {
        guard let data = components.query?.data(using: .utf8) else {
            throw invalidQueryDataError(model)
        }
        return data
    }
    
    private func cantCreateDictError<T>(_ model: T) -> EncodingError {
        return .invalidValue(model, .init(
            codingPath: [],
            debugDescription: "Can't convert model to [String : String]",
            underlyingError: nil)
        )
    }
    
    private func invalidQueryDataError<T>(_ model: T) -> EncodingError {
        return .invalidValue(model, .init(
            codingPath: [],
            debugDescription: "Error occured when trying to encode model using URL encoded format",
            underlyingError: nil)
        )
    }
    
    private func urlComponents(dict: [String : String]?) -> URLComponents {
        var urlComponents = URLComponents()
        
        urlComponents.queryItems = dict?.map { URLQueryItem(name: $0, value: $1) }
        
        return urlComponents
    }
}

public struct RequestEncoder: DataTransferRequestEncoding {
    private var encoder = JSONEncoder()
    
    public init(keyEncoding: JSONEncoder.KeyEncodingStrategy? = .convertToSnakeCase) {
        encoder.outputFormatting = .sortedKeys
        if let keyEncoding = keyEncoding {
            encoder.keyEncodingStrategy = keyEncoding
        }
    }

    public func encode<T>(_ model: T) throws -> Data where T: Encodable {
        return try encoder.encode(model)
    }
}
