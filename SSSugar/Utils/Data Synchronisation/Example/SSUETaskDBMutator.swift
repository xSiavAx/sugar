import Foundation

internal class SSUETaskDBMutator<TaskSource: SSMutatingEntitySource>: SSEntityDBMutator<TaskSource>, SSUETaskUpdate where TaskSource.Entity == SSUETask {
    public let api: SSUETaskEditApi

    public init(api mApi: SSUETaskEditApi, executor: SSExecutor, notifier: SSUpdateNotifier) {
        api = mApi
        super.init(executor:executor, notifier:notifier)
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
    private func mutateTask(pre: ((_ task: SSUETask)->())? = nil, job: @escaping (_ taskID: Int, _ marker: String)throws->SSUpdate, handler:
        @escaping (_ error: Error?)->Void) {
        if let task = source?.entity(for: self) {
            pre?(task)
            mutate(job: {try job(task.taskID, $0)}, handler: handler)
        } else {
            DispatchQueue.main.async { handler(nil) }
        }
    }
}

extension SSUETaskDBMutator: SSUETaskMutator {
    public func increment(_ handler: @escaping (Error?)->Void) {
        func check(task: SSUETask) {
            do {try task.ensureCanIncrement()} catch {fatalError(error.localizedDescription)}
        }
        func job(taskID: Int, marker: String) throws -> SSUpdate {
            try api.incrementPages(taskID:taskID)
            return incrementPages(taskID: taskID, marker: marker)
        }
        mutateTask(pre:check(task:), job:job(taskID:marker:), handler:handler)
    }
    
    public func rename(new name: String, _ handler: @escaping (Error?)->Void) {
        func job(taskID: Int, marker: String) throws -> SSUpdate {
            try api.renameTask(taskID: taskID, title: name)
            return rename(taskID: taskID, title: name, marker: marker)
        }
        mutateTask(job: job(taskID:marker:), handler: handler)
    }
    
    public func remove(_ handler: @escaping (Error?)->Void) {
        func job(taskID: Int, marker: String) throws -> SSUpdate {
            try api.removeTask(taskID:taskID)
            return remove(taskID: taskID, marker: marker)
        }
        mutateTask(job: job(taskID:marker:), handler: handler)
    }
}
