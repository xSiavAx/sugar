import Foundation

public protocol SSDataBaseStatementCacheProtocol {
    func statement(query: String) throws -> SSDataBaseStatementProtocol
    func clearOld()
    func clearOlderThen(interval: TimeInterval)
    func clearAll() throws
}

public class SSDataBaseStatementCache {
    public static let kDefaultLifeTime : TimeInterval = 60.0
    
    public enum mError: Error {
        case statementsAreInUse
    }
    
    public let lifeTime : TimeInterval
    public unowned var creator : SSDataBaseStatementCreator
    private var holders = AutoMap<String, [SSDataBaseStatementCacheHolder]>()
    
    public init(lifeTime mLifeTime: TimeInterval = SSDataBaseStatementCache.kDefaultLifeTime, statementsCreator: SSDataBaseStatementCreator) {
        lifeTime = mLifeTime
        creator = statementsCreator
    }
}

//MARK: - SSDataBaseStatementCacheProtocol

extension SSDataBaseStatementCache: SSDataBaseStatementCacheProtocol {
    public func statement(query: String) throws -> SSDataBaseStatementProtocol {
        let holder = try (cachedHolderByQuery(query) ?? createHolderForQuery(query))
        
        return SSReleaseDecorator(decorated: SSDataBaseStatementProxy(holder.statement),
                                  onCreate: { [unowned self] (stmt) in
                                    self.occupyHolder(holder)
                                },
                                  onRelease: { [unowned self] (stmt) in
                                    self.releaseHolder(holder)
                                    return false
                                })
        
    }
    
    public func clearOld() {
        clearOlderThen(interval: lifeTime)
    }
    
    public func clearOlderThen(interval: TimeInterval) {
        var indexes = AutoMap<String, [Int]>()
        
        for query in holders.keys {
            for (idx, holder) in holders[query]!.enumerated() {
                if (!holder.occupied && holder.olderThen(age: interval)) {
                    indexes.add(idx, for: query)
                    do { try holder.statement.release() } catch { fatalError("\(error)") }
                }
            }
        }
        if (!indexes.isEmpty) {
            holders.remove(forKeyAndIndexes: indexes)
        }
    }
    
    public func clearAll() throws {
        for (_, _, holder) in holders {
            guard !holder.occupied else {
                throw mError.statementsAreInUse
            }
            do { try holder.statement.release() } catch { fatalError("\(error)") }
        }
        holders.removeAll()
    }
    
    //MARK: private
    private func cachedHolderByQuery(_ query: String) -> SSDataBaseStatementCacheHolder? {
        if let queryHolders = holders[query] {
            for i in queryHolders.count-1...0 {
                if (!queryHolders[i].occupied) {
                    return queryHolders[i]
                }
            }
        }
        return nil
    }
    
    private func createHolderForQuery(_ query: String) throws -> SSDataBaseStatementCacheHolder {
        let holder = SSDataBaseStatementCacheHolder(stmt: try creator.statement(forQuery: query))
        
        holders.add(holder, for: query)
        return holder
    }
    
    private func occupyHolder(_ holder: SSDataBaseStatementCacheHolder) {
        do {
            try holder.occupy()
        } catch SSDataBaseStatementCacheHolder.mError.alreadyOccupied {
            fatalError("Holder already occupied")
        } catch {
            fatalError("Unexpected error on occupy holder \(error)")
        }
    }
    
    private func releaseHolder(_ holder: SSDataBaseStatementCacheHolder) {
        do {
            try holder.release()
        } catch SSDataBaseStatementCacheHolder.mError.notOccupied {
            fatalError("Holder not occupied")
        } catch {
            fatalError("Unexpected error on occupy holder \(error)")
        }
    }
}
