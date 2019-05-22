import Foundation

public protocol ReplaceableCollection : Collection where Element : Equatable {
    init()
    @discardableResult mutating func insert(e: Element) -> Bool
    @discardableResult mutating func remove(e: Element) -> Bool
}

public struct AutoMap<Key : Hashable, Container : ReplaceableCollection> {
    public typealias Value = Container.Element
    private (set) var count = 0
    private var map = [Key : Container]()
    
    mutating func add(key: Key, _ element: Value) -> Bool {
        if map[key] == nil {
            map[key] = Container()
        }
        if (map[key]!.insert(e:element)) {
            count += 1
            return true
        }
        return false
    }
    
    subscript(key: Key) -> Container? {
        get {
            return map[key]
        }
        set {
            if let container = newValue {
                do {
                    try replace(key: key, container: container)
                } catch {
                    fatalError(error.localizedDescription)
                }
            } else {
                remove(key: key)
            }

        }
    }
    
    @discardableResult mutating func remove(key: Key, element: Value) -> Bool {
        if (map[key]?.remove(e:element) ?? false) {
            if (map[key]?.count == 0) {
                map.removeValue(forKey: key)
            }
            count -= 1
            return true
        }
        return false
    }
    
    @discardableResult mutating func remove(key: Key) -> Container? {
        if let container = map.removeValue(forKey: key) {
            count -= container.count
            return container
        }
        return nil
    }
    
    @discardableResult mutating func removeAll() -> [Container] {
        let containers = map.values
        
        map.removeAll()
        count = 0
        return Array(containers)
    }
    
    @discardableResult mutating func replace(key: Key, container: Container) throws -> Container? {
        guard container.count > 0 else {
            throw AutoMapError.invalidContainer
        }
        let oldContainer = remove(key: key)
        
        map[key] = container
        count += container.count
        return oldContainer
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

extension AutoMap where Container : RangeReplaceableCollection & MutableCollection {
    typealias Index = Container.Index
    
    subscript(key: Key, index: Index) -> Value? {
        get {
            return map[key]?[index]
        }
        set {
            if let mValue = newValue {
                update(key: key, at: index, element: mValue)
            } else {
                remove(key: key, at: index)
            }
        }
    }
    
    mutating func insert(key: Key, at index: Container.Index, element: Value) {
        if map[key] == nil {
            map[key] = Container()
        }
        map[key]!.insert(element, at: index)
        count += 1;
    }
    
    mutating func update(key: Key, at index: Container.Index, element: Value) {
        if map[key] == nil {
            map[key] = Container()
        }
        map[key]![index] = element
        count += 1;
    }
    
    private mutating func remove(key: Key, at: Container.Index) {
        map[key]?.remove(at: at)
        count -= 1
        if (map[key]?.count == 0) {
            map.removeValue(forKey: key)
        }
    }
}

extension AutoMap : CustomStringConvertible {
    public var description: String { return "\(map)" }
}

extension AutoMap {
    enum AutoMapError: Error {
        case invalidContainer
    }
}

extension Array : ReplaceableCollection where Element : Equatable {
    public mutating func insert(e: Element) -> Bool {
        append(e)
        return true
    }

    public mutating func remove(e: Element) -> Bool {
        remove(at: firstIndex(of: e)!)
        return true
    }
}

extension Set : ReplaceableCollection {
    public mutating func insert(e: Element) -> Bool {
        return insert(e).inserted
    }
    
    public mutating func remove(e: Element) -> Bool {
        return remove(e) != nil
    }
}
