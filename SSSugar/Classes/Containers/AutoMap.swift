import Foundation

public protocol InsertableCollection : Collection {
    init()
    mutating func insert(e: Element) -> Bool
}

public protocol ReplaceableCollection : InsertableCollection {
    mutating func remove(e: Element) -> Bool
}

public struct AutoMap<Key : Hashable, Container : InsertableCollection> {
    public typealias Value = Container.Element
    public typealias Keys = Dictionary<Key, Container>.Keys
    public var isEmpty : Bool { return count == 0 }
    private (set) var count = 0
    private (set) var containers : [Key : Container]
    
    public var keys : Keys { return containers.keys }
    
    public init(map mMap : [Key : Container]) {
        count       = mMap.reduce(0) { $0 + $1.value.count }
        containers  = mMap.filter { return $1.count > 0 }
    }
    
    public init() {
        self.init(map:[Key : Container]())
    }
    
    subscript(key: Key) -> Container? {
        get {
            return containers[key]
        }
        set {
            if let container = newValue {
                replace(container, for: key)
            } else {
                remove(for: key)
            }
        }
    }
    
    @discardableResult mutating func add(container: Container, for key: Key) -> Bool {
        guard container.count != 0 && containers[key] == nil else {
            return false
        }
        addContainer(container, key: key)
        return true
    }
    
    @discardableResult mutating func add(_ element: Value, for key: Key) -> Bool {
        createContainerIfNeeded(for: key)
        if (containers[key]!.insert(e:element)) {
            count += 1
            return true
        }
        return false
    }
    
    @discardableResult mutating func replace(_ container: Container, for key: Key) -> Container? {
        guard container.count > 0 else {
            fatalError("Invalid argument. Container shouldn't be empty.")
        }
        let oldContainer = remove(for: key)
        
        addContainer(container, key: key)
        return oldContainer
    }
    
    
    @discardableResult mutating func remove(for key: Key) -> Container? {
        if let container = containers.removeValue(forKey: key) {
            count -= container.count
            return container
        }
        return nil
    }
    
    @discardableResult mutating func removeAll() -> Bool {
        if count > 0 {
            containers.removeAll()
            count = 0
            return true
        }
        return false
    }
    
    //MARK: - private
    
    private mutating func addContainer(_ container : Container, key : Key) {
        containers[key] = container
        count += container.count
    }
    
    private mutating func createContainerIfNeeded(for key: Key) {
        if containers[key] == nil {
            containers[key] = Container()
        }
    }
}

extension AutoMap where Container : ReplaceableCollection {
    @discardableResult mutating func remove(_ element: Value, for key: Key) -> Bool {
        if (containers[key]?.remove(e:element) ?? false) {
            if (containers[key]?.count == 0) {
                containers.removeValue(forKey: key)
            }
            count -= 1
            return true
        }
        return false
    }
}

extension AutoMap where Value : Equatable {
    func contains(_ value : Value, for key : Key) -> Bool {
        return containers[key]?.contains(value) ?? false
    }
}

extension AutoMap : Sequence {
    public typealias Element = (Key, Container, Value)
    
    public __consuming func makeIterator() -> AutoMap<Key, Container>.Iterator {
        return Iterator.init(map: containers)
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
            } else {
                key = nil
            }
        }
    }
}

extension AutoMap where Container : RangeReplaceableCollection & MutableCollection {
    typealias Index = Container.Index
    
    subscript(key: Key, index: Index) -> Value? {
        get {
            return containers[key]?[index]
        }
        set {
            if let mValue = newValue {
                update(mValue, for: key, at: index)
            } else {
                remove(for: key, at: index)
            }
        }
    }
    
    mutating func insert(_ element: Value, for key: Key, at index: Container.Index) {
        createContainerIfNeeded(for: key)
        containers[key]!.insert(element, at: index)
        count += 1;
    }
    
    @discardableResult mutating func update(_ element: Value, for key: Key, at index: Container.Index) -> Value {
        if let old = containers[key]?[index] {
            containers[key]![index] = element
            return old
        }
        fatalError("attempt to update a not contained \(containers[key] == nil ? "key" : "index")")
    }
    
    @discardableResult mutating func remove(for key: Key, at index: Container.Index) -> Value? {
        if let old = containers[key]?.remove(at: index) {
            count -= 1
            if (containers[key]?.count == 0) {
                containers.removeValue(forKey: key)
            }
            return old
        }
        return nil
    }
    
    @discardableResult mutating func remove(forKeyAndIndexes keysAndIndexes: AutoMap<Key, [Index]>) -> AutoMap<Key, [Value]> {
        var result = AutoMap<Key, [Value]>()
        
        for (key, indexes) in keysAndIndexes.containers {
            if containers[key] != nil {
                var values = [Value]()
                
                for index in indexes.sorted().reversed() {
                    values.append(containers[key]!.remove(at: index))
                }
                result.add(container: values.reversed(), for: key)
                if containers[key]!.count == 0 {
                    containers.removeValue(forKey: key)
                }
            }
        }
        count -= result.count
        return result
    }
}

extension AutoMap : Equatable where Container : Equatable {
    public static func == (lhs: AutoMap<Key, Container>, rhs: AutoMap<Key, Container>) -> Bool {
        if lhs.count != rhs.count {
            return false
        }
        for key in lhs.keys {
            if (lhs[key] != rhs[key]) {
                return false
            }
        }
        return true
    }
}

extension AutoMap : CustomStringConvertible {
    public var description: String { return "\(containers)" }
}

//MARK: - Standart Containers Extensions

extension Array : InsertableCollection {
    public mutating func insert(e: Element) -> Bool {
        append(e)
        return true
    }
}

extension Array : ReplaceableCollection where Element : Equatable {
    public mutating func remove(e: Element) -> Bool {
        if let index = firstIndex(of: e) {
            remove(at: index)
            return true
        }
        return false
    }
}

extension Set : InsertableCollection {
    public mutating func insert(e: Element) -> Bool {
        return insert(e).inserted
    }
    
    public mutating func remove(e: Element) -> Bool {
        return remove(e) != nil
    }
}

extension IndexSet : InsertableCollection {
    public mutating func insert(e: Element) -> Bool {
        return insert(e).inserted
    }
    
    public mutating func remove(e: Element) -> Bool {
        return remove(e) != nil
    }
}
