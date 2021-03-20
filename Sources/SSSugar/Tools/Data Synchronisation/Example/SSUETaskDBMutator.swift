import Foundation

/// Task Mutator working with DB.
///
/// For each Task mutation – mutate data via DB Api and sends coresponding Interface update via Update Notifier.
///
/// # Requires:
/// * some `SSMutatingEntitySource` with `SSUETask` as `Entity`
///
/// # Extends:
/// `SSEntityDBMutator`
/// 
/// # Conforms to:
/// `SSUETaskMutator`
internal class SSUETaskDBMutator<TaskSource: SSMutatingEntitySource>: SSEntityDBMutator<TaskSource>, SSUETaskUpdate where TaskSource.Entity == SSUETask {
    /// Task edit DB API.
    public let api: SSUETaskEditApi
    
    /// Creates new mutator.
    /// - Parameters:
    ///   - api: Task DB API
    ///   - executor: BG tasks executor.
    ///   - notifier: Update notifier.
    public init(api mApi: SSUETaskEditApi, executor: SSExecutor, notifier: SSUpdateNotifier, source: TaskSource) {
        api = mApi
        super.init(executor:executor, notifier:notifier, source: source)
    }
    
    /// Warpper that helps mutate task. It uses super's `mutate(job:handler:)` method.
    /// - Parameters:
    ///   - pre: Closure called before mutating. May be applied for any checks. Default is nil.
    ///   - task: Task to check.
    ///   - job: Mutating closure.
    ///   - taskID: Mutating task id
    ///   - marker: Modification marker
    ///   - handler: Finish handler.
    ///   - error: Finish error.
    private func mutateTask(pre: ((_ task: SSUETask)->())? = nil, handler:
        @escaping (_ error: Error?)->Void, job: @escaping (_ taskID: Int, _ marker: String) throws -> SSUpdate?) {
        if let task = source?.entity(for: self) {
            pre?(task)
            mutate(job: { try job(task.taskID, $0) }, handler: handler)
        } else {
            DispatchQueue.main.async { handler(nil) }
        }
    }
}

extension SSUETaskDBMutator: SSUETaskMutator {
    public func increment(_ handler: @escaping (Error?)->Void) {
        mutateTask(pre: { try! $0.ensureCanIncrement() }, handler:handler) {[weak self] in
            try self?.increment(taskID: $0, marker: $1)
        }
    }
    
    public func rename(new name: String, _ handler: @escaping (Error?)->Void) {
        mutateTask(handler: handler) {[weak self] in
            try self?.rename(taskID: $0, name: name, marker: $1)
        }
    }

    
    public func remove(_ handler: @escaping (Error?)->Void) {
        mutateTask(handler: handler) {[weak self] in
            try self?.removeTask($0, marker: $1)
        }
    }
    
    //MARK: private
    
    private func increment(taskID: Int, marker: String) throws -> SSUpdate {
        try api.incrementPages(taskID:taskID)
        return incrementPages(taskID: taskID, marker: marker)
    }
    
    
    private func rename(taskID: Int, name: String, marker: String) throws -> SSUpdate {
        try api.renameTask(taskID: taskID, title: name)
        return rename(taskID: taskID, title: name, marker: marker)
    }
    
    private func removeTask(_ id: Int, marker: String) throws -> SSUpdate {
        try api.removeTask(taskID:id)
        return remove(taskID: id, marker: marker)
    }
}
