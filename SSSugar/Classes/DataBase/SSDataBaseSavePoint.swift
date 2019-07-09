import Foundation

class SSDataBaseSavePoint {
    enum mError: Error {
        case alreadyFinished
    }
    let title : String
    private var finished = false
    private unowned let executor: SSDataBaseQueryExecutor
    
    init(executor mExecutor: SSDataBaseQueryExecutor, title mTitle: String) {
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
    func rollBack() throws {
        try ensureNotFinished()
        executor.exec(query: "rollback to \(title);")
        finished = true
    }
}

//MARK: SSReleasable
extension SSDataBaseSavePoint: SSReleasable {
    #warning("DB: Throw exception")
    //TODO: Decide what to do with exception.
    //We can add 'throws' to 'SSReleasable' but Statement implement it too and don't need any 'exceptions'
    func release() {
//        try ensureNotFinished()
        executor.exec(query: "release \(title);")
        finished = true
    }
}
