import Foundation

public extension Sequence {
    /// Executes a given closure using each object in the array, starting with the first object and continuing through the array to the last object.
    ///
    /// - Parameters:
    ///   - body: closure to execute for each element
    ///   - idx: current iteration element's index
    ///   - element: current iteration element
    ///
    /// - Note: Method do the same as `forEach(_ body: (Element) throws -> Void)` but additionally pass index of object to given closure. See it's documentation for more details.
    func forEach(_ body: (_ idx: Int, _ element: Element) throws -> Void) rethrows {
        var idx = 0
        try self.forEach {
            defer { idx += 1 }
            try body(idx, $0)
        }
    }
    
    func map<T>(_ build: (Int, Element) throws -> T) rethrows -> [T] {
        var idx = 0
        return try map() { element in
            defer { idx += 1 }
            return try build(idx, element)
        }
    }

    func compactMap<T>(_ build: (Int, Element) throws -> T?) rethrows -> [T] {
        var idx = 0
        return try compactMap() { element in
            defer { idx += 1}
            return try build(idx, element)
        }
    }

    func filter(_ isIncluded: (Int, Element) throws -> Bool) rethrows -> [Element] {
        var idx = 0
        return try filter() { el in
            defer { idx += 1 }
            return try isIncluded(idx, el)
        }
    }
}

