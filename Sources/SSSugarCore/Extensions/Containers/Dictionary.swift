import Foundation

public extension Dictionary {
    mutating func merge(_ dict: [Key : Value]) {
        merge(dict) { return $1 }
    }
    
    func merging(_ dict: [Key: Value]) -> [Key : Value] {
        return merging(dict) { return $1 }
    }
    
    func picking(for key: Key) -> (Self, Value)? {
        if let val = self[key] {
            var dict = self
            
            dict.removeValue(forKey: key)
            return (dict, val)
        }
        return nil
    }
    
    @discardableResult
    mutating func remove<Seq: Sequence>(for keys: Seq) -> Self where Seq.Element == Key {
        var removed = [Key : Value]()
        
        keys.forEach() { key in
            if let val = removeValue(forKey: key) {
                removed[key] = val
            }
        }
        return removed
    }
    
    func removing<Seq: Sequence>(for keys: Seq) -> (rest: Self, removed: Self) where Seq.Element == Key {
        var rest = self
        let removed = rest.remove(for: keys)
        
        return (rest: rest, removed: removed)
    }
    
    //MARK: deprecated
    
    /// - Warning: **Deprecated**. Use `init(size:buildBlock:)` instead.
    @available(*, deprecated, message: "Use `removeValue(forKey:)` instead")
    mutating func pick(for key: Key) -> Value? {
        return removeValue(forKey: key)
    }
}

public extension Dictionary where Value: SSCopying {
    /// Creates new dictionary contains copy of each values.
    func deepCopy() -> Self { mapValues { $0.copy() } }
}
