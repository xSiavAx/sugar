import Foundation
import SSSugar

struct Message: SSDBIDTable {
    static var tableName = "message"
    
    static var idColumn = id
    static var idLessColumns: [SSDBColumnProtocol] = [updateTime, relatedMessage]
    static var foreignKeys: [SSDBTableComponent] = fks(relatedMessage)
    
    static let id = SSDBColumn<Int64>(name: "id")
    static let updateTime = SSDBColumn<Date?>(name: "update_time")
    static let relatedMessage = Message.idRef(optional: true)
}

struct MessageIndex: SSDBIDTable {
    typealias IDColumn = SSDBColumnRef<Message, SSDBColumn<Int64>>
    
    static var tableName = "message_index"
    
    static var idColumn: IDColumn = messageID
    static var idLessColumns: [SSDBColumnProtocol] = []
    
    static let messageID = Message.idRef()
}

func main() {
    let prints = [MessageIndex.createQuery()]
    print(prints.joined(separator: "\n"))
}

main()
