import Foundation

public extension Dictionary {
    mutating func merge(_ dict: [Key : Value]) {
        merge(dict) { return $1 }
    }
    
    func merging(_ dict: [Key: Value]) -> [Key : Value] {
        return merging(dict) { return $1 }
    }
    
    mutating func pick(for key: Key) -> Value? {
        if let val = self[key] {
            self.removeValue(forKey: key)
            return val
        }
        return nil
    }
    
    func picking(for key: Key) -> (Self, Value)? {
        if let val = self[key] {
            var dict = self
            dict.removeValue(forKey: key)
            return (dict, val)
        }
        return nil
    }
}

public extension Dictionary where Value: SSCopying {
    /// Creates new dictionary contains copy of each values.
    func deepCopy() -> Self { mapValues { $0.copy() } }
}
