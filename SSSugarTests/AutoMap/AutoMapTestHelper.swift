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
 [] remove(_:for:)
 [] remove(for:at:)
 [] remove(forKeyAndIndexes:)
 [] insert(_:for:at:)
 [] update(_:for:at:)
 
 // Static Methods
 [] ==
 
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
    case odds
    case fibonacci
    case empty
    case new
    case evensAdd
    case evensNew
    case evensChanged
    case evensWithoutElement
    
    static let addValue = 999111
    static let evensFirstContainedValue = 2
    static let evensSecondContainedValue = 4
    static let evensThirdContainedValue = 6
    static let evensLastContainedValue = 8
    static let evensNotContainedValue = -1
    static let evensChangedValue = 10
    static let evensChangedIndex = 2
    static let evensWithoutElementIndex = 2
    
    var key: AutoMapTestDefaultItem {
        switch self {
        case .evensAdd, .evensNew, .evensChanged, .evensWithoutElement:
            return .evens
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
        case .odds:
            return [1, 3, 5, 7]
        case .fibonacci:
            return [3, 5, 8, 13]
        case .empty:
            return []
        case .new:
            return [Self.addValue]
        case .evensAdd:
            return Self.evens.array + [Self.addValue]
        case .evensNew:
            return [12, 14, 16, 18]
        case .evensChanged:
            var array = Self.evens.array
            array[Self.evensChangedIndex] = Self.evensChangedValue
            return array
        case .evensWithoutElement:
            var array = Self.evens.array
            array.remove(at: Self.evensWithoutElementIndex)
            return array
        }
    }
}
