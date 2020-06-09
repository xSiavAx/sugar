import Foundation

/// Task Mutator working with Network.
///
/// See `SSEntityRemoteMutator` for more info. Implements `SSUETaskUpdateReceiver` to match updates on newtwork mutating requests and to determine mutating finish.
///
/// # Requires:
/// * some `SSMutatingEntitySource` with `SSUETask` as `Entity`
///
/// # Extends:
/// `SSEntityRemoteMutator`
///
/// # Conforms to:
/// `SSUETaskMutator`, `SSUETaskUpdateReceiver`
internal class SSUETaskRemoteMutator<TaskSource: SSMutatingEntitySource>: SSEntityRemoteMutator<TaskSource> where TaskSource.Entity == SSUETask {
    /// Task remote modification Type
    /// - Parameters:
    ///   - taskID: Mutating task id
    ///   - marker: Modification marker
    ///   - handler: Finish handler.
    private typealias TaskAsyncJob = (_ taskdID: Int, _ marker: String, _ handler: @escaping Handler)->Void
    /// Task newtwork edit API
    internal let api: SSUETaskEditAsyncApi
    
    /// Creates new mutator.
    /// - Parameters:
    ///   - api: Task Edit asynchroniously API (newtwork API)
    ///   - manager: Update receiver's manager
    internal init(api mApi: SSUETaskEditAsyncApi, manager: SSUpdateReceiversManaging, source: TaskSource) {
        api = mApi
        super.init(manager: manager, source: source)
    }
    
    /// Warpper that helps mutate task. It uses super's `mutate(job:handler:)` method.
    /// - Parameters:
    ///   - taskJob: Task mutating job to execute.
    ///   - handler: Finish handler.
    private func mutate(taskJob: @escaping TaskAsyncJob, handler: @escaping Handler) throws {
        if let task = source?.entity(for: self) {
            func job(marker: String, handler: @escaping Handler) {
                taskJob(task.taskID, marker, handler)
            }
            try mutate(job: job(marker:handler:), handler: handler)
        }
    }
    
    override func reactions() -> SSUpdate.ReactionMap {
        return taskReactions()
    }
}

extension SSUETaskRemoteMutator: SSUETaskMutator {
    public func increment(_ handler: @escaping Handler) throws {
        try mutate(taskJob: api.incrementPages(taskID:marker:handler:), handler: handler)
    }
    
    public func rename(new name: String, _ handler: @escaping Handler) throws {
        func rename(taskID: Int, marker: String, handler: @escaping Handler) {
            api.renameTask(taskID: taskID, title: name, marker: marker, handler: handler)
        }
        try mutate(taskJob: rename(taskID:marker:handler:), handler: handler)
    }
    
    public func remove(_ handler: @escaping Handler) throws {
        try mutate(taskJob: api.removeTask(taskID:marker:handler:), handler: handler)
    }
}

extension SSUETaskRemoteMutator: SSUETaskUpdateReceiver {
    public func taskDidIncrementPages(taskID: Int, marker: String?) {
        handleUpdate(with: marker!)
    }
    
    public func taskDidRename(taskID: Int, title: String, marker: String?) {
        handleUpdate(with: marker!)
    }
    
    public func taskDidRemove(taskID: Int, marker: String?) {
        handleUpdate(with: marker!)
    }
}
