import Foundation
import SSSugarCore

struct Contact: SSDBIDTable {
    static var tableName: String { "contact" }
    static var idColumn = id
    static var idLessColumns: [SSDBColumnProtocol] = [firstName, lastName, birthDay, color, initials, notes, company]
    
    static let id = SSDBColumn<Int>(name: "id")
    static let firstName = SSDBColumn<String?>(name: "first_name")
    static let lastName = SSDBColumn<String?>(name: "last_name")
    static let birthDay = SSDBColumn<Date?>(name: "birth_day")
    static let color = SSDBColumn<Int?>(name: "color")
    static let initials = SSDBColumn<String?>(name: "initials")
    static let notes = SSDBColumn<String?>(name: "notes")
    static let company = SSDBColumn<String?>(name: "company")
}

struct ContactGroup: SSDBIDTable {
    static let tableName: String = "contact_group"
    
    static var idColumn = id
    static var idLessColumns: [SSDBColumnProtocol] = [title]
    static var indexes: [SSDBTableIndexProtocol]? = idxs(unique: true) { $0.title }
    
    static let id = SSDBColumn<Int>(name: "id")
    static let title = SSDBColumn<String>(name: "title")
}

struct ContactGroupRel: SSDBTable {
    static var tableName: String = "contact_group_contact_relation"
    
    static var primaryKey: SSDBPrimaryKeyProtocol? = pk(contact, group)
    static var colums: [SSDBColumnProtocol] = [group, contact]
    static var foreignKeys: [SSDBTableComponent] = fks(group, contact)
    
    static var group = ContactGroup.idRef()
    static var contact = Contact.idRef()
}

struct DynamicStorage: SSDBStoraging {
    static let name = "Dynamic"
    static var tables: [SSDBTable.Type] = [
                                           Message.self,
                                           ]
    var db: SSDataBase
    
    init(identifier: String) throws {
        db = try .dbWith(name: Self.name, prefix: identifier)
    }
    
    struct Message: SSDBIDTable {
        static var tableName = "message"
        
        static var idColumn = id
        static var idLessColumns: [SSDBColumnProtocol] = [flags, icon, hasAttach, updateTime, relatedMessage, relationType]
        static var indexes: [SSDBTableIndexProtocol] = idxs(unique: true, { $0.flags }, { $0.icon }, { $0.hasAttach })
        static var foreignKeys: [SSDBTableComponent] = fks(relatedMessage)
        
        static let id = SSDBColumn<Int64>(name: "id")
        
        static let flags = SSDBColumn<Int>(name: "flags")
        static let icon = SSDBColumn<Int>(name: "icon")
        static let hasAttach = SSDBColumn<Bool>(name: "has_attach")
        
        static let updateTime = SSDBColumn<Date?>(name: "update_time")
        static let relatedMessage = Message.idRef(prefix: "related", optional: true)
        static let relationType = SSDBColumn<Int?>(name: "relation_type")
    }
}

func main() {
    let prints = [Contact.selectAllQuery(), Contact.selectQuery(),
                  ContactGroup.selectAllQuery(), ContactGroup.selectQuery(),
                  ContactGroupRel.selectAllQuery(), ContactGroupRel.selectQuery()]
    print(prints.joined(separator: "\n"))
    let dynamic = try! DynamicStorage(identifier: "test@ukr.net")
    
    try! dynamic.deinitializeStructure(strictExist: false)
    try! dynamic.initializeStructure()
    try! dynamic.deinitializeStructure()
}

main()
