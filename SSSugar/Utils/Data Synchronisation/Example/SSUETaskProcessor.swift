import Foundation

internal class SSUETaskObtainer {
    var taskID: Int
    var api: SSUETaskApi
    
    public init(taskID mTaskID: Int, api mApi: SSUETaskApi) {
        taskID = mTaskID
        api = mApi
    }
}

extension SSUETaskObtainer: SSEntityObtainer {
    public func obtain() -> SSUETask? {
        return api.getTask(taskID: taskID)
    }
}

internal protocol SSUETaskProcessorDelegate: AnyObject {
    func processor(_ processor: SSUETaskProcessor, didIncrementPages oldPages: Int)
    func processor(_ processor: SSUETaskProcessor, didRenameTask oldTitle: String)
    func processorDidRemoveTask(_ processor: SSUETaskProcessor)
}

internal class SSUETaskProcessor: SSEntityProcessor<SSUETaskObtainer> {
    public var task: SSUETask?
    public weak var delegate: SSUETaskProcessorDelegate?
    
    public init(taskID: Int, updater: SSUpdateReceiversManaging, executor: SSExecutor, taskApi: SSUETaskApi) {
        let obtainer = SSUETaskObtainer(taskID: taskID, api: taskApi)
        super.init(obtainer: obtainer, updater: updater, executor: executor)
    }
}

extension SSUETaskProcessor: SSUETaskUpdateReceiver {
    public func taskDidIncrementPages(taskID: Int, marker: String?) {
        func increment() {
            if let mTask = checkedTask(taskID: taskID) {
                let old = mTask.pages
                
                do {try mTask.incrementPages()} catch {fatalError(error.localizedDescription)}
                delegate?.processor(self, didIncrementPages: old)
            }
        }
        onMain(increment)
    }
    
    public func taskDidRename(taskID: Int, title: String, marker: String?) {
        func rename() {
            if let mTask = checkedTask(taskID: taskID) {
                let old = mTask.title
                
                mTask.title = title
                delegate?.processor(self, didRenameTask: old)
            }
        }
        onMain(rename)
    }
    
    public func taskDidRemove(taskID: Int, marker: String?) {
        func remove() {
            if let _ = checkedTask(taskID: taskID) {
                delegate?.processorDidRemoveTask(self)
                task = nil
            }
        }
        onMain(remove)
    }
    
    private func checkedTask(taskID: Int) -> SSUETask? {
        return task?.taskID == taskID ? task : nil
    }
}
