import Foundation
import SSSugar

extension DynamicStorage {
    struct ContactGroup: SSDBTableWithID {
        static let tableName: String = "contact_group"
        
        static var idColumn: SSDBColumnProtocol = id
        static var idLessColumns: [SSDBColumnProtocol] = [title]
        static var indexCols: [SSDBColumnProtocol]? = [title] 
        
        static let id = SSDBColumn<Int>(name: "id", primaryKey: true)
        static let title = SSDBColumn<String>(name: "title", unique: true)
        
        static func save() -> SSDBQueryProcessor<String, Void> {
            return SSDBQueryProcessor(saveQuery(), onBind: { try $0.bind($1) })
        }
        
        static func remove() -> SSDBQueryProcessor<Int, Void> {
            return SSDBQueryProcessor(removeQuery(), onBind: { try $0.bind($1) })
        }
        
        static func removeByName() -> SSDBQueryProcessor<String, Void> {
            let rmQuery = try! query(.delete).add(colCondition: title).build()
            return SSDBQueryProcessor(rmQuery, onBind: { try $0.bind($1) })
        }
        
        static func rename() -> SSDBQueryProcessor<(id: Int, title: String), Void> {
            return SSDBQueryProcessor(updateQuery(cols: [title]), onBind:{(stmt, args) in
                try stmt.bind(args.title)
                try stmt.bind(args.id)
            });
        }
        
        static func renameByName() -> SSDBQueryProcessor<(oldTitle: String, newTitle: String), Void> {
            return SSDBQueryProcessor(updateQuery(cols: [title]), onBind:{(stmt, args) in
                try stmt.bind(args.newTitle)
                try stmt.bind(args.oldTitle)
            });
        }
        
        static func select() -> SSDBQueryProcessor<(Int), (id: Int, title: String)> {
            return SSDBQueryProcessor(removeQuery(), onBind: { try $0.bind($1) }) {
                return (id: try $0.get(), title: try $0.get())
            }
        }
        
        static func selectByName() -> SSDBQueryProcessor<(String), (id: Int, title: String)> {
            let query = try! selectAllQueryBuilder().add(colCondition: title).build()
            
            return SSDBQueryProcessor(query, onBind: { try $0.bind($1) }) {
                return (id: try $0.get(), title: try $0.get())
            }
        }
    }
}
