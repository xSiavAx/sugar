import Foundation

public class SSDataBaseSavePoint {
    enum mError: Error {
        case alreadyFinished
    }
    public let title : String
    
    private var finished = false
    private unowned let executor: SSDataBaseQueryExecutor
    
    public init(executor mExecutor: SSDataBaseQueryExecutor, title mTitle: String) {
        executor = mExecutor
        title = mTitle
        executor.exec(query: "savepoint \(title);")
    }
    
    //MARK: - private
    private func ensureNotFinished() throws {
        guard finished else {
            throw mError.alreadyFinished
        }
    }
}

//MARK: - SSDataBaseSavePointProtocol
extension SSDataBaseSavePoint: SSDataBaseSavePointProtocol {
    public func rollBack() throws {
        try ensureNotFinished()
        executor.exec(query: "rollback to \(title);")
        finished = true
    }
}

//MARK: SSReleasable
extension SSDataBaseSavePoint: SSReleasable {
    public func release() throws {
        try ensureNotFinished()
        executor.exec(query: "release \(title);")
        finished = true
    }
}
