import Foundation

public class SSDataBaseStatementCacheHolder {
    public enum mError: Error {
        case alreadyOccupied
        case notOccupied
    }
    public var statement : SSDataBaseStatementProtocol
    private(set) var occupied = false
    private(set) var lastUsed : Date? = nil
    
    public init(stmt: SSDataBaseStatementProtocol) {
        statement = stmt
    }
    
    //MARK: - public
    public func occupy(date: Date = Date()) throws {
        try ensureNotOccupied()
        lastUsed = date
        occupied = true
    }
    
    public func release() throws {
        try ensureOccupied()
        try statement.clear()
        try statement.reset()
        occupied = false
    }
    
    public func olderThen(age: TimeInterval) -> Bool {
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
