import Foundation

public extension Array {
    init(size: Int, buildBlock:(Int)->(Element)) {
        #warning("Swift 5.1")
        //FIXME: Replace by new swift 5.1 array constructor
        self.init((0..<size).map(buildBlock))
    }
    
    func binarySearch(_ needle: Element, comparator: (Element, Element)->ComparisonResult) -> Int? {
        return bSearchIdxAndLastIdx(needle, comparator: comparator).0
    }
    
    func binarySearch(forInsert needle: Element, comparator: (Element, Element)->ComparisonResult) -> Int {
        let lastIDx = bSearchIdxAndLastIdx(needle, comparator: comparator).1

        if (count > 0 && comparator(self[lastIDx], needle) == .orderedAscending) {
            return lastIDx + 1
        }
        return lastIDx
    }
    
    func forEach(_ body: (Element, Int) throws -> Void) rethrows {
        var idx = 0;
        
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
    func binarySearch(_ needle: Element) -> Int? {
        return binarySearch(needle) {$0.compare($1)}
    }
    
    func binarySearch(forInsert needle: Element) -> Int {
        return binarySearch(forInsert:needle) {$0.compare($1)}
    }
}
