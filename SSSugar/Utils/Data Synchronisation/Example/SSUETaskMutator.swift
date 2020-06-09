import Foundation

/// Requirements for any mutator that works with Task entity
internal protocol SSUETaskMutator {
    /// Increments number of task's pages
    /// - Parameter handler: Finish handler
    func increment(_ handler: @escaping (Error?)->Void) throws
    /// Renames task
    /// - Parameters:
    ///   - name: Task's new title
    ///   - handler: Finish handler
    func rename(new name: String, _ handler: @escaping (Error?)->Void) throws
    /// Removes task
    /// - Parameter handler: Finish handler
    func remove(_ handler: @escaping (Error?)->Void) throws
}
