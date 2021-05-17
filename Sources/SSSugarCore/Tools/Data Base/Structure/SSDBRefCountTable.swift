import Foundation

public protocol SSDBRefCountTable: SSDBTable {
    static var refCount: SSDBColumn<Int> { get }
}

//MARK: - Release Trigger creating

public extension SSDBRefCountTable {
    static func createRefCount(name: String = "ref_count") -> SSDBColumn<Int> {
        return col(name, defaultVal: 0)
    }
    
    static func releaseTrigger(whereCols cols: [SSDBColumnProtocol]) -> SSDBTrigger {
        let queryBuilder = query(.delete)
        
        cols.forEach { try! queryBuilder.add(colCondition: $0, .equal, value: "new.\($0.nameFor(select: false))") }
        
        return SSDBTrigger(name: "ref_count_release",
                           table: self,
                           actionCondition: .after,
                           action: .update(of: [refCount]),
                           condition: "new.`\(refCount.nameFor(select: false))` == 0",
                           statements: [try! queryBuilder.build()])!
    }
    
    static func releaseTrigger() -> SSDBTrigger {
        guard let pk = primaryKey else { fatalError("Primary key ins't defined") }
        return releaseTrigger(whereCols: pk.cols)
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
    typealias OnWhereBuild = (_ builder: SSDBQueryBuilder, _ colPrefix: String) throws -> SSDBQueryBuilder
    
    static func updateTriggers(for otherTable: SSDBTable.Type, match: OnWhereBuild) -> [SSDBTrigger] {
        return [increaseTrigger(for: otherTable, whereBuild: match),
                decreaseTrigger(for: otherTable, whereBuild: match)]
    }
    
    static func updateTriggers(ref: SSDBColumnRefProtocol) -> [SSDBTrigger] {
        return updateTriggers(for: ref.table) {
            return try addConditionTo(builder: $0, refTableCol: ref.reference, prefix: $1, triggerTableCol: ref)
        }
    }
    
    static func updateTriggersWithCols(col: SSDBColumnProtocol, otherTCol: SSDBColumnProtocol) -> [SSDBTrigger] {
        return updateTriggers(for: otherTCol.table) {
            return try addConditionTo(builder: $0, refTableCol: col, prefix: $1, triggerTableCol: otherTCol)
        }
    }
    
    static func increaseTrigger(for otherTable: SSDBTable.Type, whereBuild: OnWhereBuild) -> SSDBTrigger {
        return SSDBTrigger(name: "content_ref_count_increase",
                           table: otherTable,
                           actionCondition: .after,
                           action: .insert,
                           statements: [updateRefCountQuery(.increase, whereBuild: whereBuild)])!
        
    }
    
    static func decreaseTrigger(for otherTable: SSDBTable.Type, whereBuild: OnWhereBuild) -> SSDBTrigger {
        return SSDBTrigger(name: "content_ref_count_decrease",
                           table: otherTable,
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
                                       triggerTableCol: SSDBColumnProtocol) throws -> SSDBQueryBuilder {
        return try builder.add(colCondition: refTableCol, .equal, value: "\(prefix).`\(triggerTableCol.nameFor(select: false))`")
    }
}


