import Foundation

//MARK: - Hex representation

public extension Data {
    /// Encoding options
    ///
    /// * `upperCase` – representation will has uppercased digit's symbols (default is lowercased)
    struct HexEncodingOptions: OptionSet {
        public let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
        
        public init(rawValue mRawValue: Int) {
            rawValue = mRawValue
        }
    }

    /// Creates new Data instance based on it's hex-decimal representation
    /// - Parameter hexString: Hexdecimal respresentation to build data with
    /// - Complexity: O(N), where N is data length
    /// - Returns: Created data or nil if string is invalid
    ///
    /// String length should be even number cuz each symbols pair represent 1 byte. String may contain `0x` prefix or doesn't.
    init?(hexString: String) {
        guard hexString.count % 2 == 0 else { return nil }
        var (index, count) = Self.indexAndCount(fromHex: hexString)
        var bytes = [UInt8]()
        
        bytes.reserveCapacity(count)
        
        for _ in (0..<count) {
            let nextIndex = hexString.index(index, offsetBy: 2)
            guard let byte = UInt8(hexString[index..<nextIndex], radix: 16) else { return nil }
            
            index = nextIndex
            
            bytes.append(byte)
        }
        self.init(bytes)
    }
    
    /// Hexadecimal string representation of `Data` object.
    /// - Parameter options: Encoding options. Default is none.
    /// - Complexity: O(N), where N is data length
    ///
    /// Result string will not contain `0x` prefix
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }

    //MARK: class private
    
    private static func indexAndCount(fromHex string: String) -> (String.Index, Int) {
        let start = string.startIndex
        let count = string.count / 2
        
        if (string.starts(with: "0x")) {
            return (string.index(start, offsetBy: 2), count - 1)
        }
        return (start, count)
    }
}

//MARK: - Base64url encoded representation

public extension Data {
    init?(base64urlEncoded: String) {
        let base64 = Self.fromBase64url(text: base64urlEncoded)
        let suffixLength = base64.count % 4
        let suffix = (0..<suffixLength).map { _ in "=" }.joined()

        self.init(base64Encoded: base64.appending(suffix))
    }

    func base64urlEncodedString() -> String {
        let base64url = Self.toBase64url(text: base64EncodedString())
        
        return Self.truncSuffix(text:base64url)
    }
    
    //MARK: class private
    
    private static func toBase64url(text: String) -> String {
        return text.replacingOccurrences(of: "+", with: "-").replacingOccurrences(of: "/", with: "_")
    }
    
    private static func fromBase64url(text: String) -> String {
        return text.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
    }
    
    private static func truncSuffix(text: String) -> String {
        guard let index = indexBeforeSuffix(text: text) else { return "" }
        
        if (index != text.endIndex) {
            return String(text[...index])
        }
        return text
    }
    
    private static func indexBeforeSuffix(text: String) -> String.Index? {
        if (text.count == 0) {
            return nil
        }
        var index = text.index(before: text.endIndex)
        
        while (text[index] == "=") {
            if (index == text.startIndex) {
                return nil
            }
            index = text.index(before: index)
        }
        return index
    }
}

