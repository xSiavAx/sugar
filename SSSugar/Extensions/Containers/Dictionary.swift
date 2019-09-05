import Foundation

public extension Dictionary {
    mutating func merge(_ dict: [Key : Value]) {
        merge(dict) { return $1 }
    }
    
    func merging(_ dict: [Key: Value]) -> [Key : Value] {
        return merging(dict) { return $1 }
    }
}
