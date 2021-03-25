import Foundation
import SSSugar

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
    static var indexes: [SSDBTableIndexProtocol]? = idxs() { $0.title }
    
    static let id = SSDBColumn<Int>(name: "id")
    static let title = SSDBColumn<String>(name: "title", unique: true)
}

struct ContactGroupRel: SSDBTable {
    static var tableName: String = "contact_group_contact_relation"
    
    static var primaryKey: SSDBPrimaryKeyProtocol? = pk(contact, group)
    static var colums: [SSDBColumnProtocol] = [group, contact]
    static var foreignKeys: [SSDBTableComponent] = [group.fk(), contact.fk()]
    
    static var group = ContactGroup.idRef()
    static var contact = Contact.idRef()
}

func main() {
    print(Contact.createQuery())
    print(ContactGroup.createQuery())
    print(ContactGroupRel.createQuery())
}

main()
