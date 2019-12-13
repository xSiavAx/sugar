import Foundation

#warning("Improove.")
//TODO: How to replace 'Any' by type?
internal protocol SSUETaskUpdaterDelegate: SSEntityUpdaterDelegate {
    func updater(_ updater: Any, didIncrementPages oldPages: Int)
    func updater(_ updater: Any, didRenameTask oldTitle: String)
    func updaterDidRemoveTask(_ updater: Any)
}

internal protocol SSUETaskSource: SSUpdaterEntitySource where Entity == SSUETask {}

internal class SSUETaskUpdater<TaskSource: SSUETaskSource, TaskDelegate: SSUETaskUpdaterDelegate>: SSBaseEntityUpdating {
    typealias Source = TaskSource
    typealias Delegate = TaskDelegate

    weak var delegate: TaskDelegate?
    weak var source: TaskSource?
    var receiversManager: SSUpdateReceiversManaging
    
    init(receiversManager mReceiversManager: SSUpdateReceiversManaging) {
        receiversManager = mReceiversManager
    }

    private func checkedTask(_ taskID: Int) -> SSUETask? {
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
