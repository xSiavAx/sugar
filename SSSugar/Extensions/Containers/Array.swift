import Foundation

public extension Array {
    init(size: Int, buildBlock:(Int)->(Element)) {
        #warning("Swift 5.1")
        //FIXME: Replace by new swift 5.1 array constructor
        self.init((0..<size).map(buildBlock))
    }
    
    /// Returns any index whose corresponding array value is equal to a given object using Binary Search algorithm.
    ///
    /// - Important:
    /// Since Binary Search requiere sorted data, passed array should be sorted with given comparator. But this requierement give Time advantage.
    /// - Note:
    /// Argument `comparator` may be skipped for Arrays whose elements implement `Comparable`. See `binarySearch(_ needle: Element) -> Int?`
    /// - Complexity: O(logN)
    /// - Parameters:
    ///   - needle: An object to search
    ///   - comparator: Comparator to check objects equality and search direction, should return `ComparisonResult` for passed arguments.
    ///   - cNeedle: Needle that will be compared with array element
    ///   - cElement: Array element that will be compared with needle
    /// - Returns: Index of searching object. If none of the objects in the array is equal to needle, returns nil.
    func binarySearch(_ needle: Element, comparator: (_ cNeedle:Element, _ cElement:Element)->ComparisonResult) -> Int? {
        return bSearchIdxAndLastIdx(needle, comparator: comparator).0
    }
    
    /// Returns any index using which result array of inserting object still be sorted. For index search used Binary Search Algorithm.
    ///
    /// - Important:
    /// Obviously passed array should be sorted. Otherwise method may produce unexpected result.
    /// - Note:
    /// Argument `comparator` may be skipped for Arrays whose elements implement `Comparable`. See `binarySearch(forInsert needle: Element) -> Int`
    /// - Parameters:
    ///   - needle: An object to search insert position for
    ///   - comparator: Comparator to check objects equality and search direction, should return `ComparisonResult` for passed arguments.
    ///   - cNeedle: Needle that will be compared with array element
    ///   - cElement: Array element that will be compared with needle
    /// - Returns: Index for inserting subject object.
    func binarySearch(forInsert needle: Element, comparator: (_ cNeedle:Element, _ cElement:Element)->ComparisonResult) -> Int {
        let lastIDx = bSearchIdxAndLastIdx(needle, comparator: comparator).1

        if (count > 0 && comparator(self[lastIDx], needle) == .orderedAscending) {
            return lastIDx + 1
        }
        return lastIDx
    }
    
    /// Executes a given closure using each object in the array, starting with the first object and continuing through the array to the last object.
    ///
    /// - Parameters:
    ///   - body: closure to execute for each element
    ///   - cElement: current iteration element
    ///   - cIdx: current iteration element's index
    ///
    /// - Note: Method do the same as `forEach(_ body: (Element) throws -> Void)` but additionally pass index of object to given closure. See it's documentation for more details.
    func forEach(_ body: (_ cElement:Element, _ cIdx:Int) throws -> Void) rethrows {
        var idx = 0
        
        try self.forEach { (element) in
            try body(element, idx)
            idx += 1
        }
    }
    
    //MARK: - deprecated
    /// - Warning: **Deprecated**. Use `init(size:buildBlock:)` instead.
    @available(*, deprecated, message: "Use `init(size:buildBlock:)` instead")
    static func array(size: Int, buildBlock:(Int)->(Element)) -> Array<Element> {
        return (0..<size).map(buildBlock)
    }
    
    //MARK: - private
    private func bSearchIdxAndLastIdx(_ needle: Element, comparator: (Element, Element)->ComparisonResult) -> (Int?, Int) {
        var range = 0..<count
        var lastIDx = 0
        
        while !range.isEmpty {
            lastIDx = range.middle
            
            switch comparator(needle, self[lastIDx]) {
            case .orderedSame:
                return (lastIDx, lastIDx)
            case .orderedAscending:
                range = range.prefix(upTo: lastIDx)
            case .orderedDescending:
                range = range.suffix(from: lastIDx + 1)
            }
        }
        return (nil, lastIDx)
    }
}

public extension Array where Element : Comparable {
    /// Shortcut for Array whose elements implements Comparable. See `binarySearch(_ needle: Element, comparator: (_ cNeedle:Element, _ cElement:Element)->ComparisonResult) -> Int?` for full description.
    func binarySearch(_ needle: Element) -> Int? {
        return binarySearch(needle) {$0.compare($1)}
    }
    
    /// Shortcut for Array whose elements implements Comparable. See `binarySearch(forInsert needle: Element, comparator: (_ cNeedle:Element, _ cElement:Element)->ComparisonResult) -> Int` for full description.
    func binarySearch(forInsert needle: Element) -> Int {
        return binarySearch(forInsert:needle) {$0.compare($1)}
    }
}
