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

    private func checkedUpdate(_ taskID: Int, job: (inout SSUETask) -> () -> Void) {
        var onDone: (()->Void)? = nil
        
        protUpdate() {
            if let task = $0, task.taskID == taskID {
                onDone = job(&($0!))
            }
        }
        onDone?()
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
        checkedUpdate(taskID) {(task) in
            let old = task.pages

            try! task.incrementPages()
            return { self.delegate?.updater(self, didIncrementPages: old) }
        }
    }
    
    private func rename(taskID: Int, title: String) {
        checkedUpdate(taskID) {(task) in
            let old = task.title

            task.title = title
            return { self.delegate?.updater(self, didRenameTask: old) }
        }
    }
    
    private func remove(taskID: Int) {
        var removed = false
        
        protUpdate() {(task) in
            if (task?.taskID == taskID) {
                task = nil
                removed = true
            }
        }
        if (removed) {
            delegate?.updaterDidRemoveTask(self)
        }
    }
}
