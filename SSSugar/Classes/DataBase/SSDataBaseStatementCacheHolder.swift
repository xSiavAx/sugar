import Foundation

class SSDataBaseStatementCacheHolder {
    enum mError: Error {
        case alreadyOccupied
        case notOccupied
    }
    var statement : SSDataBaseStatementProtocol
    private(set) var occupied = false
    private(set) var lastUsed : Date? = nil
    
    init(stmt: SSDataBaseStatementProtocol) {
        statement = stmt
    }
    
    //MARK: - public
    func occupy(date: Date = Date()) throws {
        try ensureNotOccupied()
        lastUsed = date
        occupied = true
    }
    
    func release() throws {
        try ensureOccupied()
        occupied = false
    }
    
    func olderThen(age: TimeInterval) -> Bool {
        if let mLastUsed = lastUsed {
            return (Date() - age) > mLastUsed
        }
        return true
    }
    
    //MARK: - private
    private func ensureNotOccupied() throws {
        guard !occupied else {
            throw mError.alreadyOccupied
        }
    }
    
    private func ensureOccupied() throws {
        guard occupied else {
            throw mError.notOccupied
        }
    }
}
