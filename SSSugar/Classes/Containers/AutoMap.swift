import Foundation

public protocol ReplaceableCollection : Collection where Element : Equatable {
    init()
    mutating func insert(e: Element)
    mutating func remove(e: Element)
}

public struct AutoMap<Key : Hashable, Container : ReplaceableCollection> {
    public typealias Value = Container.Element
    private var map = [Key : Container]()
    
    mutating func add(key: Key, _ element: Value) {
        if map[key] == nil {
            map[key] = Container()
        }
        map[key]!.insert(e:element)
    }
    
    mutating func remove(key: Key, element: Value) {
        map[key]?.remove(e:element)
        if (map[key]?.count == 0) {
            map.removeValue(forKey: key)
        }
    }
    
    mutating func remove(key: Key) {
        map.removeValue(forKey: key)
    }
    
    mutating func removeAll() {
        map.removeAll()
    }
}

extension AutoMap : Sequence {
    public typealias Element = (Key, Container, Value)
    
    public __consuming func makeIterator() -> AutoMap<Key, Container>.Iterator {
        return Iterator.init(map: map)
    }
    
    public class Iterator : IteratorProtocol {
        public typealias Element = AutoMap.Element
        
        private var iterator : Dictionary<Key, Container>.Iterator
        private var key : Key?
        private var containerIterator : Container.Iterator!
        private var container : Container!
        
        init(map : [Key : Container]) {
            iterator = map.makeIterator()
            mapIteratorNext()
        }
        
        public func next() -> Element? {
            while key != nil {
                if let val = containerIterator.next() {
                    return (key!, container, val)
                }
                mapIteratorNext()
            }
            return nil
        }
        
        private func mapIteratorNext() {
            if let (mKey, mContainer) = iterator.next() {
                key = mKey
                container = mContainer
                containerIterator = mContainer.makeIterator()
            }
        }
    }
}

extension AutoMap where Container : RangeReplaceableCollection {
    typealias Index = Container.Index
    
    subscript(key: Key, index: Index) -> Value? {
        get {
            return map[key]?[index]
        }
        set {
            if let mValue = newValue {
                insert(key: key, at: index, element: mValue)
            } else {
                remove(key: key, at: index)
            }
        }
    }
    
    private mutating func insert(key: Key, at index: Container.Index, element: Value) {
        if map[key] == nil {
            map[key] = Container()
        }
        map[key]!.insert(element, at: index)
    }
    
    private mutating func remove(key: Key, at: Container.Index) {
        map[key]?.remove(at: at)
        if (map[key]?.count == 0) {
            map.removeValue(forKey: key)
        }
    }
}

extension AutoMap : CustomStringConvertible {
    public var description: String { return "\(map)" }
}

extension Array : ReplaceableCollection where Element : Equatable {
    public mutating func insert(e: Element) {
        append(e)
    }

    public mutating func remove(e: Element) {
        remove(at: firstIndex(of: e)!)
    }
}

extension Set : ReplaceableCollection {
    public mutating func insert(e: Element) {
        insert(e)
    }
    
    public mutating func remove(e: Element) {
        remove(e)
    }
}

