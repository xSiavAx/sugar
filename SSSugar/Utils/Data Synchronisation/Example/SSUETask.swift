import Foundation

/// Simple entity class for Data Synchronisation class usages demonstration
internal class SSUETask {
    enum mError: Error {
        case pagesLimitReached
    }
    
    /// Task identifie
    internal var taskID: Int
    /// Task title
    internal var title: String
    /// Number of pages in task
    internal private(set) var pages: Int
    
    /// Creates new task instance
    /// - Parameters:
    ///   - taskID: Task's identifier
    ///   - title: Task's title
    ///   - pages: Number of Task's pages
    internal init(taskID mTaskID: Int, title mTitle: String, pages mPages: Int) {
        taskID = mTaskID
        title = mTitle
        pages = mPages
    }
    
    /// Increment number of Task's pages
    /// Can throw 'pagesLimitReached' on pages limit reached
    internal func incrementPages() throws {
        try ensureCanIncrement()
        pages += 1
    }
    
    /// Check number of Task's pages may be incremented.
    /// Throw 'pagesLimitReached' if can't.
    internal func ensureCanIncrement() throws {
        guard canIncrement() else {
            throw mError.pagesLimitReached
        }
    }
    
    private func canIncrement() -> Bool {
        return pages < 100
    }
}
