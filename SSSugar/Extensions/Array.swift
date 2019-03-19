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
}
