import Foundation

/// Simple entity class for Data Synchronisation class usages demonstration
///
/// # Conforms to:
/// `SSCopying`
internal struct SSUETask: Hashable, Equatable, CustomStringConvertible {
    /// Task's pages limit.
    static let maxPages = 100
    
    /// Errors may occur during works with Task
    enum mError: Error {
        case pagesLimitReached
    }
    
    /// Task identifier
    internal let taskID: Int
    /// Task title
    internal var title: String
    /// Number of pages in task
    internal private(set) var pages: Int
    
    var description: String { return "Task '\(title)' [\(pages)]" }
    
    /// Increment number of Task's pages
    /// Can throw 'pagesLimitReached' on pages limit reached
    internal mutating func incrementPages() throws {
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
        return pages < Self.maxPages
    }
}
