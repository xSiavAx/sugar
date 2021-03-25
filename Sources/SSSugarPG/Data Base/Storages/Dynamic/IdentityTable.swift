import Foundation
import SSSugar

extension DynamicStorage {
    struct Identity: SSDBTableWithID {
        typealias IdentityArgs = (email: String, name: String, isConfirmed: Bool, isDefault: Bool, isSystem: Bool)
        
        static let tableName: String = "Identity"
        static var idColumn: SSDBColumnProtocol = email
        static var idLessColumns: [SSDBColumnProtocol] = [name, isConfirmed, isDefault, isSystem]
        
        static let email = SSDBColumn<String>(name: "email", primaryKey: true)
        static let name = SSDBColumn<String>(name: "name")
        static let isConfirmed = SSDBColumn<Bool>(name: "is_onfirmed", defaultVal: false)
        static let isDefault = SSDBColumn<Bool>(name: "is_default", defaultVal: false)
        static let isSystem = SSDBColumn<Bool>(name: "is_system", defaultVal: false)
        
        static func save() -> SSDBQueryProcessor<IdentityArgs, Void> {
            return SSDBQueryProcessor(insertQuery(), onBind: {(stmt, args) in
                try stmt.bind(args.email)
                try stmt.bind(args.name)
                try stmt.bind(args.isConfirmed)
                try stmt.bind(args.isDefault)
                try stmt.bind(args.isSystem)
            })
        }
        
        static func selectByEmail() -> SSDBQueryProcessor<String, IdentityArgs> {
            return SSDBQueryProcessor(selectQuery(), onBind: { try $0.bind($1) }, onGet: {(stmt) in
                return (email: try stmt.get(),
                        name: try stmt.get(),
                        isConfirmed: try stmt.get(),
                        isDefault: try stmt.get(),
                        isSystem: try stmt.get())
            });
        }
        
        static func remove() -> SSDBQueryProcessor<String, Void> {
            return SSDBQueryProcessor(removeQuery(), onBind: { try $0.bind($1) })
        }
        
        static func currentDefaultID() -> SSDBQueryProcessor<Void, String> {
            return currentDefault(cols: [idColumn]) { try $0.get() }
        }
        
        static func systemIDs() -> SSDBQueryProcessor<Void, String> {
            let builder = query(.select).add(cols: [email]).add(colCondition: isSystem, .equal, value: "1")
            return SSDBQueryProcessor(try! builder.build(), onGet: { try $0.get() })
        }
        
        static func changeDefault() -> SSDBQueryProcessor<(email: String, isDefault: Bool), Void> {
            return SSDBQueryProcessor(updateQuery(cols: [isDefault]), onBind: {(stmt, args) in
                try stmt.bind(args.isDefault)
                try stmt.bind(args.email)
            })
        }
        
        static func changeConfirmed() -> SSDBQueryProcessor<(email: String, isConfirmed: Bool), Void> {
            return SSDBQueryProcessor(updateQuery(cols: [isConfirmed]), onBind: {(stmt, args) in
                try stmt.bind(args.isConfirmed)
                try stmt.bind(args.email)
            })
        }
        
        static func changeName() -> SSDBQueryProcessor<(email: String, name: String), Void> {
            return SSDBQueryProcessor(updateQuery(cols: [name]), onBind: {(stmt, args) in
                try stmt.bind(args.name)
                try stmt.bind(args.email)
            })
        }
        
        static func changeEmail() -> SSDBQueryProcessor<(email: String, newEmail: String), Void> {
            return SSDBQueryProcessor(updateQuery(cols: [email]), onBind: {(stmt, args) in
                try stmt.bind(args.newEmail)
                try stmt.bind(args.email)
            })
        }
        
        private static func currentDefault<T>(cols: [SSDBColumnProtocol], onGet: @escaping ((SSDataBaseStatementProcessor) throws -> T)) -> SSDBQueryProcessor<Void, T> {
            let builder = query(.select).add(cols: cols).add(colCondition: isDefault, .equal, value: "1")
            return SSDBQueryProcessor(try! builder.build(), onGet: onGet)
        }
    }
}
