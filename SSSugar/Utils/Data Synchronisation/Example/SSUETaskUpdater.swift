import Foundation

internal protocol SSUETaskUpdaterDelegate: SSEntityUpdaterDelegate {
    func updater(_ updater: AnyObject, didIncrementPages oldPages: Int)
    func updater(_ updater: AnyObject, didRenameTask oldTitle: String)
    func updaterDidRemoveTask(_ updater: AnyObject)
}

internal class SSUETaskUpdater<TaskSource: SSUpdaterEntitySource, TaskDelegate: SSUETaskUpdaterDelegate>: SSEntityUpdater<TaskSource, TaskDelegate> where TaskSource.Entity == SSUETask {

    private func checkedTask(_ taskID: Int) -> Entity? {
        if let task = entity, task.taskID == taskID {
            return task
        }
        return nil
    }
}

extension SSUETaskUpdater: SSUETaskUpdateReceiver {
    func taskDidIncrementPages(taskID: Int, marker: String?) {
        func increment() {
            if let mTask = checkedTask(taskID) {
                let old = mTask.pages
                
                do {try mTask.incrementPages()} catch {fatalError(error.localizedDescription)}
                delegate?.updater(self, didIncrementPages: old)
            }
        }
        onMain(increment)
    }
    
    func taskDidRename(taskID: Int, title: String, marker: String?) {
        func rename() {
            if let mTask = checkedTask(taskID) {
                let old = mTask.title
                
                mTask.title = title
                delegate?.updater(self, didRenameTask: old)
            }
        }
        onMain(rename)
    }
    
    func taskDidRemove(taskID: Int, marker: String?) {
        func remove() {
            if let _ = checkedTask(taskID) {
                delegate?.updaterDidRemoveTask(self)
            }
        }
        onMain(remove)
    }
}
