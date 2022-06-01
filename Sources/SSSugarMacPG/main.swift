import Foundation
import SSSugarCore
import SSSugarDatabase

struct Contact: SSDBIDTable {
    static var tableName: String { "contact" }
    static var idColumn = id
    static var idLessColumns: [SSDBColumnProtocol] = [firstName, lastName, birthDay, color, initials, notes, company]
    
    static let id = col("id", type: Int.self)
    static let firstName = col("first_name", type: String?.self)
    static let lastName = col("last_name", type: String?.self)
    static let birthDay = col("birth_day", type: Date?.self)
    static let color = col("color", type: Int?.self)
    static let initials = col("initials", type: String?.self)
    static let notes = col("notes", type: String?.self)
    static let company = col("company", type: String?.self)
}

struct ContactGroup: SSDBIDTable {
    static let tableName: String = "contact_group"
    
    static var idColumn = id
    static var idLessColumns: [SSDBColumnProtocol] = [title]
    static var indexes: [SSDBTableIndexProtocol]? = [idx(unique: true, title)]
    
    static let id = col("id", type: Int.self)
    static let title = col("title", type: String.self)
}

struct ContactGroupRel: SSDBTable {
    static var tableName: String = "contact_group_contact_relation"
    
    static var primaryKey: SSDBPrimaryKeyProtocol? = pk(contact, group)
    static var colums: [SSDBColumnProtocol] = [group, contact]
    static var foreignKeys: [SSDBTableComponent] = fks(group, contact)
    
    static var group = ContactGroup.idRef(for: Self.self)
    static var contact = Contact.idRef(for: Self.self)
}

struct DynamicStorage: SSDBStoraging {
    static let name = "Dynamic"
    static var tables: [SSDBTable.Type] = [
                                           Message.self,
                                           ]
    private(set) var db: SSDataBaseProtocol
    
    init(identifier: String) throws {
        self.db = try SSDataBase.dbWith(name: Self.name, prefix: identifier)
    }
    
    struct Message: SSDBIDTable {
        static var tableName = "message"
        
        static var idColumn = id
        static var idLessColumns: [SSDBColumnProtocol] = [flags, icon, hasAttach, updateTime, relatedMessage, relationType]
        static var indexes: [SSDBTableIndexProtocol] = [idx(unique: false, flags), idx(unique: false, icon), idx(unique: false, hasAttach)]
        static var foreignKeys: [SSDBTableComponent] = fks(relatedMessage)
        
        static let id = col("id", type: Int64.self)

        static let flags = col("flags", type: Int.self)
        static let icon = col("icon", type: Int.self)
        static let hasAttach = col("has_attach", type: Bool.self)

        static let updateTime = col("update_time", type: Date?.self)
        static let relatedMessage = Message.idRef(for: Self.self, prefix: "related", optional: true)
        static let relationType = col("relation_type", type: Int?.self)
    }
}

func main() {
//    let prints = [Contact.selectAllQuery(), Contact.selectQuery(),
//                  ContactGroup.selectAllQuery(), ContactGroup.selectQuery(),
//                  ContactGroupRel.selectAllQuery(), ContactGroupRel.selectQuery()]
//    print(prints.joined(separator: "\n"))
//    let dynamic = try! DynamicStorage(identifier: "test@ukr.net")
//
//    try! dynamic.deinitializeStructure(strictExist: false)
//    try! dynamic.initializeStructure()
//    try! dynamic.deinitializeStructure()
    
//    RunLoop.current.run()
}

main()
