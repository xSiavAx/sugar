import Foundation

//MARK: - Base64url

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

