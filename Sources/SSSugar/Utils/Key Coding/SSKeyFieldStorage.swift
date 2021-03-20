import Foundation

public protocol SSKeyFieldStorage {
    subscript(key: String) -> Any? {get set}
}

extension Dictionary: SSKeyFieldStorage where Key == String, Value == Any {}

extension UserDefaults: SSKeyFieldStorage {
    public subscript(key: String) -> Any? {
        get { value(forKey: key) }
        set {
            if (newValue == nil) {
                removeObject(forKey: key)
            } else {
                setValue(newValue, forKey: key)
            }
        }
    }
}
