import Foundation

public protocol SSDBRefCountTable: SSDBTable {
    static var refCount: SSDBColumn<Int> { get }
}

//MARK: - Release Trigger creating

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

//MARK: - Update Ref Count Triggers creating

enum RefCountUpdate: String {
    case increase = "+ 1"
    case decrease = "- 1"
    
    var columnSpace: String {
        switch self {
        case .increase: return "new"
        case .decrease: return "old"
        }
    }
}

public extension SSDBRefCountTable {
    typealias OnWhereBuild = (_ builder: SSDBQueryBuilder, _ colPrefix: String) -> SSDBQueryBuilder
    
    static func updateTriggers<OtherTable: SSDBTable>(match: OnWhereBuild) -> [SSDBTrigger<OtherTable>] {
        return [increaseTrigger(whereBuild: match), decreaseTrigger(whereBuild: match)]
    }
    
    static func updateTriggers<TriggerTable: SSDBTable, Column: SSDBTypedColumnProtocol>(colReference: (TriggerTable.Type) -> SSDBColumnRef<Self, Column>) -> [SSDBTrigger<TriggerTable>] {
        return updateTriggers() {
            let reference = colReference(TriggerTable.self)
            
            return addConditionTo(builder: $0, refTableCol: reference.column, prefix: $1, triggerTableCol: reference)
        }
    }
    
    static func updateTriggersWithCols<TriggerTable: SSDBTable>(_ matchCols: (Self.Type, TriggerTable.Type) -> (SSDBColumnProtocol, SSDBColumnProtocol)) -> [SSDBTrigger<TriggerTable>] {
        return updateTriggers() {
            let cols = matchCols(Self.self, TriggerTable.self)
            
            return addConditionTo(builder: $0, refTableCol: cols.0, prefix: $1, triggerTableCol: cols.1)
        }
    }
    
    static func increaseTrigger<OtherTable: SSDBTable>(whereBuild: OnWhereBuild) -> SSDBTrigger<OtherTable> {
        return SSDBTrigger(name: "content_ref_count_increase",
                           actionCondition: .after,
                           action: .insert,
                           statements: [updateRefCountQuery(.increase, whereBuild: whereBuild)])!
        
    }
    
    static func decreaseTrigger<OtherTable: SSDBTable>(whereBuild: OnWhereBuild) -> SSDBTrigger<OtherTable> {
        return SSDBTrigger(name: "content_ref_count_decrease",
                           actionCondition: .after,
                           action: .delete,
                           statements: [updateRefCountQuery(.decrease, whereBuild: whereBuild)])!
        
    }
    
    private static func updateRefCountQuery(_ update: RefCountUpdate, whereBuild: OnWhereBuild) -> String {
        return try! whereBuild(query(.update), update.columnSpace).update(col: refCount, build: { "\($0) \(update.rawValue)" }).build()
    }
    
    private static func addConditionTo(builder: SSDBQueryBuilder,
                                       refTableCol: SSDBColumnProtocol,
                                       prefix: String,
                                       triggerTableCol: SSDBColumnProtocol) -> SSDBQueryBuilder {
        return builder.add(colCondition: refTableCol, .equal, value: "\(prefix).`\(triggerTableCol.name)`")
    }
}


