import Foundation

#warning("Improove.")
//TODO: How to replace 'Any' by type?
/// Requirements for Task Updater's delegate.
internal protocol SSUETaskUpdaterDelegate: SSEntityUpdaterDelegate {
    /// Updater did increment task's pages
    /// - Parameters:
    ///   - updater: Updater made modification
    ///   - oldPages: Old pages number value
    func updater(_ updater: Any, didIncrementPages oldPages: Int)
    
    /// Updater did rename task
    /// - Parameters:
    ///   - updater: Updater made modification
    ///   - oldTitle: Task's old title
    func updater(_ updater: Any, didRenameTask oldTitle: String)
    
    /// Updater did remove task
    /// - Parameter updater: Updater made modification
    func updaterDidRemoveTask(_ updater: Any)
}

/// Requirements for Task entity source.
///
/// # Entends:
/// `SSUpdaterEntitySource`
internal protocol SSUETaskSource: SSUpdaterEntitySource where Entity == SSUETask {}

/// Task updater.
///
/// Reacts on task updates (`SSUETaskUpdateReceiver`), modifies entity and calls coresponding delegate's method.
///
/// # Requires:
/// * some `SSUETaskSource`
/// * some `SSUETaskUpdaterDelegate`
///
/// # Conforms to:
/// `SSBaseEntityUpdating`, `SSUETaskUpdateReceiver`
internal class SSUETaskUpdater<TaskSource: SSUETaskSource, TaskDelegate: SSUETaskUpdaterDelegate>: SSBaseEntityUpdating {
    typealias Source = TaskSource
    typealias Delegate = TaskDelegate
    
    /// Collected Task updates (uses in `apply()`)
    var collectedUpdates = [CollectableUpdate]()
    var receiversManager: SSUpdateReceiversManaging
    
    weak var delegate: TaskDelegate?
    weak var source: TaskSource?
    
    init(receiversManager mReceiversManager: SSUpdateReceiversManaging, source mSource: TaskSource, delegate mDelegate: TaskDelegate) {
        receiversManager = mReceiversManager
        source = mSource
        delegate = mDelegate
    }

    private func checkedTask(_ taskID: Int) -> SSUETask? {
        if let task = entity, task.taskID == taskID {
            return task
        }
        return nil
    }
}

extension SSUETaskUpdater: SSUpdateApplying {}

extension SSUETaskUpdater: SSUETaskUpdateReceiver {
    func taskDidIncrementPages(taskID: Int, marker: String?) {
        collect() {[weak self] in
            self?.increment(taskID: taskID)
        }
    }
    
    func taskDidRename(taskID: Int, title: String, marker: String?) {
        collect() {[weak self] in
            self?.rename(taskID: taskID, title: title)
        }
    }

    func taskDidRemove(taskID: Int, marker: String?) {
        collect() {[weak self] in
            self?.remove(taskID: taskID)
        }
    }
    
    //MARK: private
    
    private func increment(taskID: Int) {
        if let mTask = checkedTask(taskID) {
            let old = mTask.pages

            do {try mTask.incrementPages()} catch { fatalError(error.localizedDescription) }
            delegate?.updater(self, didIncrementPages: old)
        }
    }
    
    private func rename(taskID: Int, title: String) {
        if let mTask = checkedTask(taskID) {
            let old = mTask.title

            mTask.title = title
            delegate?.updater(self, didRenameTask: old)
        }
    }
    
    private func remove(taskID: Int) {
        if let _ = checkedTask(taskID) {
            delegate?.updaterDidRemoveTask(self)
        }
    }
}
