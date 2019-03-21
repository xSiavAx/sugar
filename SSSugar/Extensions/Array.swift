import Foundation

extension Array {
    func binarySearch(needle: Element, comparator: (Element, Element)->ComparisonResult) -> Int? {
        var range = 0..<count
        
        while !range.isEmpty {
            let middle = range.middle()

            switch comparator(needle, self[middle]) {
            case .orderedSame:
                return middle
            case .orderedAscending:
                range = range.suffix(from: middle + 1)
            case .orderedDescending:
                range = range.prefix(upTo: middle - 1)
            }
        }
        return nil
    }
    
    func forEach(_ body: (Element, Int) throws -> Void) rethrows {
        var idx = 0;
        
        try self.forEach { (element) in
            try body(element, idx)
            idx += 1
        }
    }
    
    static func array(size: Int, buildblock:(Int)->(Element)) -> Array {
        return (0..<size).map(buildblock)
    }
}
