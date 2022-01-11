import Foundation

public extension Array {
    init(size: Int, buildBlock:(Int)->(Element)) {
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
    /// - Complexity: O(logN)
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
    
    //MARK: - deprecated
    
    /// - Warning: **Deprecated**. Use `init(size:buildBlock:)` instead.
    @available(*, deprecated, message: "Use `init(size:buildBlock:)` instead")
    static func array(size: Int, buildBlock:(Int)->(Element)) -> Array<Element> {
        return (0..<size).map(buildBlock)
    }
    
    //MARK: - deprecated
    
    /// - Warning: **Deprecated**. Use `foreach(size:buildBlock:)` instead.
    @available(*, deprecated, message: "Use `forEach(_ body: ((idx: element:)) throws -> Void)` instead")
    func forEach(_ body: (_ cElement:Element, _ cIdx:Int) throws -> Void) rethrows {
        try forEach() { idx, element in
            try body(element, idx)
        }
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

public extension Array {
    mutating func pick(at index: Index) -> Element {
        let element = self[index]
        
        remove(at: index)
        return element
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

public extension Array where Element: SSCopying {
    /// Creates new array contains copy of each element
    func deepCopy() -> Self { map { $0.copy() } }
}
