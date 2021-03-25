import Foundation
import SSSugar

struct Contact: SSDBIDTable {
    static var tableName: String { "contact" }
    static var idColumn: SSDBColumn<Int> { id }
    static var idLessColumns: [SSDBRegualColumnProtocol] = [firstName, lastName, birthDay, color, initials, notes, company]
    
    static let id = SSDBColumn<Int>(name: "id", primaryKey: true)
    static let firstName = SSDBColumn<String?>(name: "first_name")
    static let lastName = SSDBColumn<String?>(name: "last_name")
    static let birthDay = SSDBColumn<Date?>(name: "birth_day")
    static let color = SSDBColumn<Int?>(name: "color")
    static let initials = SSDBColumn<String?>(name: "initials")
    static let notes = SSDBColumn<String?>(name: "notes")
    static let company = SSDBColumn<String?>(name: "company")
}

struct ContactEmail: SSDBTable {
    static let tableName = "contact_email"
    static var regularColumns: [SSDBRegualColumnProtocol] = [value]
    static var refCoulmns: [SSDBColumnRefProtocol] = [contact]
    
    static var indexCols: [SSDBRegualColumnProtocol]? = [value]
    static var foreignKeys: [SSDBTableComponent] = fks() { $0.contact }
    
    static let value = SSDBColumn<String>(name: "value")
    static let contact = Contact.idRef()
}

func main() {
    print(ContactEmail.createQuery())
}

main()
