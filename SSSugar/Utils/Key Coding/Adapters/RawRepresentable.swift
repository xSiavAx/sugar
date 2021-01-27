import Foundation

//TODO: See how we could upgrade SSErrorConverter and SSApiErrorConverter using RawRepresentable.
// For that purpouses we could add `to`, `from`, `read` and `write` to RawRepresentable.
public extension RawRepresentable {
    typealias KeyFieldOptAdapter = SSKeyField<Self?>.Adapter
    typealias KeyFieldAdapter = SSKeyField<Self>.Adapter
    
    static func keyFieldOptAdapter() -> KeyFieldOptAdapter {
        func to(val: Any?) -> Self? {
            guard let raw = val as? RawValue else { return nil }
            return Self(rawValue: raw)
        }
        func from(val: Self?) -> Any? {
            return val?.rawValue
        }
        return KeyFieldOptAdapter(to: to, from: from)
    }
    
    static func keyFieldAdapter() -> KeyFieldAdapter {
        func to(val: Any?) -> Self {
            return Self(rawValue: val as! RawValue)!
        }
        func from(val: Self) -> Any? {
            return val.rawValue
        }
        return KeyFieldAdapter(to: to, from: from)
    }
}
