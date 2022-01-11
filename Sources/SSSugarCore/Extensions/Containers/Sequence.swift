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
        
        try self.forEach { (element) in
            defer { idx += 1 }
            try body(idx, element)
        }
    }
}

