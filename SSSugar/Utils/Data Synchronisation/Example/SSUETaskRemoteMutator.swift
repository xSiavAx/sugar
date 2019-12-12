import Foundation

internal class SSUETaskRemoteMutator<TaskSource: SSMutatingEntitySource>: SSEntityRemoteMutator<TaskSource> where TaskSource.Entity == SSUETask {
    private typealias TaskAsyncJob = (Int, String, Handler)->Void
    public let api: SSUETaskEditAsyncApi
    
    public init(api mApi: SSUETaskEditAsyncApi, manager: SSUpdateReceiversManaging) {
        api = mApi
        super.init(manager: manager)
    }
    
    private func mutate(taskJob: @escaping TaskAsyncJob, handler: @escaping Handler) {
        if let task = source?.entity(for: self) {
            func job(marker: String, handler: Handler) {
                taskJob(task.taskID, marker, handler)
            }
            mutate(job: job(marker:handler:), handler: handler)
        }
    }
}

extension SSUETaskRemoteMutator: SSUETaskMutator {
    public func increment(_ handler: @escaping Handler) {
        mutate(taskJob: api.incrementPages(taskID:marker:handler:), handler: handler)
    }
    
    public func rename(new name: String, _ handler: @escaping Handler) {
        func rename(taskID: Int, marker: String, handler: Handler) {
            api.renameTask(taskID: taskID, title: name, marker: marker, handler: handler)
        }
        mutate(taskJob: rename(taskID:marker:handler:), handler: handler)
    }
    
    public func remove(_ handler: @escaping Handler) {
        mutate(taskJob: api.removeTask(taskID:marker:handler:), handler: handler)
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
