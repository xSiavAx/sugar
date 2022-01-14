import Foundation

public extension Array {
    init(size: Int, buildBlock:(Int)->(Element)) {
        self.init((0..<size).map(buildBlock))
    }
    
    mutating func pick(at index: Index) -> Element {
        let element = self[index]
        
        remove(at: index)
        return element
    }
    
    //MARK: deprecated
    
    /// - Warning: **Deprecated**. Use `init(size:buildBlock:)` instead.
    @available(*, deprecated, message: "Use `init(size:buildBlock:)` instead")
    static func array(size: Int, buildBlock:(Int)->(Element)) -> Array<Element> {
        return (0..<size).map(buildBlock)
    }
}

//MARK: - Binary Search

public extension Array {
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
    
    //MARK: private

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

//MARK: - Shuffle

public extension Array {
    /// Array shuffle algorithm type
    /// * `bultin` – Swift standrart library algorithm
    /// * `durstenfeld` – Richard's Durstenfeld algorithm (Fisher-Yates algorithm modification)
    /// - Note: Bult-in algorithm realization may be various from version to version, that why custom realisation of Richard's Durstenfeld algorithm may be usefull.
    enum ShuffleType {
        case bultin
        case durstenfeld
    }
    
    /// Shuffles the collection in place, using the given generator as a source for randomness.
    ///
    /// You use this method with `.durstenfeld` if bultin algorithm doesn't meet your requirements. For example, u need stable shuffle algorithm realization from version to version.
    /// - Complexity: O(N) for `.durstenfeld`. For `.bultin` see `func shuffle<T>(using:)` doc. Usually it's O(N).
    /// - SeeAlso: `func shuffle<T>(using:)`
    /// - Parameters:
    ///   - generator: The random number generator to use when shuffling the collection.
    ///   - type: Type of shuffle algorithm
    mutating func shuffle<T: RandomNumberGenerator>(using generator: inout T, type: ShuffleType) {
        switch type {
        case .bultin:
            shuffle(using: &generator)
        case .durstenfeld:
            shuffleDurstenfeld(using: &generator)
        }
    }
    
    /// Returns the elements of the sequence, shuffled using the given generator as a source for randomness.
    ///
    /// You use this method with `.durstenfeld` if bultin algorithm doesn't meet your requirements. For example, u need stable shuffle algorithm realization from version to version.
    /// - Complexity: O(N) for `.durstenfeld`. For `.bultin` see `func shuffled<T>(using:)` doc. Usually it's O(N).
    /// - SeeAlso: `func shuffled<T>(using:)` and `func shuffle<T>(using: type:)`
    /// - Parameters:
    ///   - generator: The random number generator to use when shuffling the sequence.
    ///   - type: Type of shuffle algorithm
    /// - Returns: An array of this sequence’s elements in a shuffled order.
    func shuffled<T: RandomNumberGenerator>(using generator: inout T, type: ShuffleType) -> Self {
        switch type {
        case .bultin:
            return shuffled(using: &generator)
        case .durstenfeld:
            var new = self
            
            new.shuffle(using: &generator, type: .durstenfeld)
            return new
        }
    }
    
    //MARK: - private
    /// Richard's Durstenfeld shuffle algorithm (Fisher-Yates algorithm modification)
    /// - Parameter generator: The random number generator to use when shuffling the sequence.
    private mutating func shuffleDurstenfeld<T>(using generator: inout T) where T : RandomNumberGenerator {
        (0..<count).reversed().forEach {
            let rand = generator.next(upperBound: UInt($0+1), type: .remainder)
            swapAt($0, Int(rand))
        }
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
