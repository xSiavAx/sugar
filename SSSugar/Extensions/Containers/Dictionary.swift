import Foundation

extension Dictionary {
    mutating func merge(_ dict: [Key : Value]) {
        for (key, value) in dict { self[key] = value }
    }
    
    func merging(_ dict: [Key: Value]) -> [Key : Value] {
        var result = self
        
        result.merge(dict)
        return result
    }
}
