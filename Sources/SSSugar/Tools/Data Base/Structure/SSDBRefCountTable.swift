import Foundation

public protocol SSDBRefCountTable: SSDBTable {
    static var refCount: SSDBColumn<Int> { get }
}

public extension SSDBRefCountTable {
    static func createRefCount(name: String = "ref_count") -> SSDBColumn<Int> {
        return SSDBColumn<Int>(name: name, defaultVal: 0)
    }
    
    static func releaseTrigger(whereCols cols: [SSDBColumnProtocol]) -> SSDBTrigger<Self> {
        let queryBuilder = query(.delete)
        
        cols.forEach { queryBuilder.add(colCondition: $0, .equal, value: "new.`\($0.name)`") }
        
        return SSDBTrigger(name: "ref_count_release",
                           actionCondition: .after,
                           action: .update(of: [refCount]),
                           condition: "new.`\(refCount.name)` == 0",
                           statements: [try! queryBuilder.build()])!
    }
}

public extension SSDBRefCountTable where Self: SSDBIDTable {
    static func releaseTrigger() -> SSDBTrigger<Self> {
        return releaseTrigger(whereCols: [idColumn])
    }
}

