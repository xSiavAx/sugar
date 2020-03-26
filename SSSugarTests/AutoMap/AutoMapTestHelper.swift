/*
 
 Tests for AutoMap
 
 // Methods
 [Done] init(), init(map:)
 [Done] add(_:for:)
 [Done] add(container:for:)
 [Done] contains(_:for:)
 [Done] replace(_:for:)
 [Done] removeAll()
 [Done] remove(for:)
 [Done] remove(for:at:)
 [Done] remove(_:for:)
 [Done] remove(forKeyAndIndexes:)
 [Done] insert(_:for:at:)
 [Done] update(_:for:at:)
 
 // Static Methods
 [Done] ==
 
 // Subscripts
 [Done] subscript(key:)
 [Done] subscript(key:index:)
 
 // Properties
 [Done] isEmpty
 [Done] count
 
 Проверить доступность методов AutoMap как составляющую импортированного фреймворка (public)
 
 */

import XCTest
@testable import SSSugar

struct AutoMapTestHelper {    
    func arrayMap(from items: AutoMapTestDefaultItem...) -> [AutoMapTestDefaultItem : [Int]] {
        var map = [AutoMapTestDefaultItem : [Int]]()
        
        items.forEach { map[$0.key] = $0.array }
        return map
    }
    
    func setMap(from items: AutoMapTestDefaultItem...) -> [AutoMapTestDefaultItem : Set<Int>] {
        var map = [AutoMapTestDefaultItem : Set<Int>]()
        
        items.forEach { map[$0.key] = $0.set }
        return map
    }
    
    func assertEqual<Container: InsertableCollection & Equatable>(_ automap: AutoMap<AutoMapTestDefaultItem, Container>, _ dict: [AutoMapTestDefaultItem : Container]) {
        XCTAssertEqual(automap.keys, dict.keys)
        
        for key in automap.keys {
            XCTAssertEqual(automap[key], dict[key])
        }
    }
}

enum AutoMapTestDefaultItem {
    case evens
    case evensIndices
    case evensAdd
    case evensNew
    case evensChanged
    case evensWithoutElement
    case evensWithoutTwoIndices
    case odds
    case oddsIndices
    case oddsInserted
    case fibonacci
    case empty
    case new
    
    static let addValue = 999111
    static let evensFirstContainedValue = 2
    static let evensSecondContainedValue = 4
    static let evensThirdContainedValue = 6
    static let evensLastContainedValue = 8
    static let evensNotContainedValue = -1
    static let evensChangedValue = 10
    static let evensChangedIndex = 2
    static let evensWithoutElementIndex = 2
    static let evensWithoutElementValue = Self.evens.array[evensWithoutElementIndex]
    static let evensContaindeIndex = 2
    static let evensNotContainedIndex = 999
    static let oddsInsertedIndex = 3
    static let oddsInsertedValue = 99
    
    var firstOfTwoIndex: Int { 0 }
    var secondOfTwoIndex: Int { array.count - 1 }
    
    var key: AutoMapTestDefaultItem {
        switch self {
        case .evensIndices, .evensAdd, .evensNew, .evensChanged, .evensWithoutElement, .evensWithoutTwoIndices:
            return .evens
        case .oddsIndices, .oddsInserted:
            return .odds
        default:
            return self
        }
    }
    var set: Set<Int> {
        switch self {
        case .empty:
            return Set()
        default:
            return Set(array)
        }
    }
    var array: [Int] {
        switch self {
        case .evens:
            return [
                Self.evensFirstContainedValue,
                Self.evensSecondContainedValue,
                Self.evensThirdContainedValue,
                Self.evensLastContainedValue
            ]
        case .evensIndices:
            return Array(Self.evens.array.indices)
        case .evensAdd:
            return Self.evens.array + [Self.addValue]
        case .evensNew:
            return [12, 14, 16, 18]
        case .evensChanged:
            return getEvensArrayChnaged()
        case .evensWithoutElement:
            return getEvensArrayWithoutElement()
        case .evensWithoutTwoIndices:
            return getEvensArrayWithoutTwoIndices()
        case .odds:
            return [1, 3, 5, 7]
        case .oddsIndices:
            return Array(Self.odds.array.indices)
        case .oddsInserted:
            return getOddsArrayWithInsertedValue()
        case .fibonacci:
            return [3, 5, 8, 13]
        case .empty:
            return []
        case .new:
            return [Self.addValue]
        }
    }
    var keyAndTwoIndices: [Self : [Int]] {
        [self : [firstOfTwoIndex, secondOfTwoIndex]]
    }
    var reversedKeyAndTwoIndices: [Self : [Int]] {
        [self : [secondOfTwoIndex, firstOfTwoIndex]]
    }
    var keyAndTwoValues: [Self : [Int]] {
        [self : [array[firstOfTwoIndex], array[secondOfTwoIndex]]]
    }
    
    private func getEvensArrayChnaged() -> [Int] {
        var array = Self.evens.array
        
        array[Self.evensChangedIndex] = Self.evensChangedValue
        return array
    }
    
    private func getEvensArrayWithoutElement() -> [Int] {
        var array = Self.evens.array
        
        array.remove(at: Self.evensWithoutElementIndex)
        return array
    }
    
    private func getEvensArrayWithoutTwoIndices() -> [Int] {
        var array = Self.evens.array
        
        array.remove(at: Self.evens.secondOfTwoIndex)
        array.remove(at: Self.evens.firstOfTwoIndex)
        return array
    }
    
    private func getOddsArrayWithInsertedValue() -> [Int] {
        var array = Self.odds.array
        
        array.insert(Self.oddsInsertedValue, at: Self.oddsInsertedIndex)
        return array
    }
}
