import Foundation

/// Array shuffle algorithm type
/// * `bultin` – Swift standrart library algorithm
/// * `durstenfeld` – Richard's Durstenfeld algorithm (Fisher-Yates algorithm modification)
/// - Note: Bult-in algorithm realization may be various from version to version, that why custom realisation of Richard's Durstenfeld algorithm may be usefull.
enum SequenceShuffleType {
    case bultin
    case durstenfeld
}

public extension Sequence {
    /// Executes a given closure using each object in the array, starting with the first object and continuing through the array to the last object.
    ///
    /// - Parameters:
    ///   - body: closure to execute for each element
    ///   - idx: current iteration element's index
    ///   - element: current iteration element
    ///
    /// - Note: Method do the same as `forEach(_ body: (Element) throws -> Void)` but additionally pass index of object to given closure. See it's documentation for more details.
    func forEach(_ body: ((idx: Int, element: Element)) throws -> Void) rethrows {
        var idx = 0
        
        try self.forEach { (element) in
            defer { idx += 1 }
            try body(idx, element)
        }
    }
    
    /// Shuffles the collection in place, using the given generator as a source for randomness.
    ///
    /// You use this method with `.durstenfeld` if bultin algorithm doesn't meet your requirements. For example, u need stable shuffle algorithm realization from version to version.
    /// - Complexity: O(N) for `.durstenfeld`. For `.bultin` see `func shuffle<T>(using:)` doc. Usually it's O(N).
    /// - SeeAlso: `func shuffle<T>(using:)`
    /// - Parameters:
    ///   - generator: The random number generator to use when shuffling the collection.
    ///   - type: Type of shuffle algorithm
    mutating func shuffle<T>(using generator: inout T, type: SequenceShuffleType) where T : RandomNumberGenerator {
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
    func shuffled<T>(using generator: inout T, type: SequenceShuffleType) -> Self where T : RandomNumberGenerator {
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

