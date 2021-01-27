import Foundation

/// Protocol with requirements to creating Task related updates
/// - Note:
/// Default implementation are provided in extension. Any class implementing this protocol may not implemnt methods and use their default implementation.
internal protocol SSUETaskUpdate {
    /// Creates new SSUpdate for increment Task's pages
    /// - Parameters:
    ///   - taskID: Task identifier for pages increment
    ///   - marker: Update identifier
    func incrementPages(taskID: Int, marker: String) -> SSUpdate
    
    /// Creates new SSUpdate for rename Task
    /// - Parameters:
    ///   - taskID: Task identifier for pages increment
    ///   - title: NEw title for task
    ///   - marker: Update identifier
    func rename(taskID: Int, title: String, marker: String) -> SSUpdate
    
    /// Creates new SSUpdate for remove Task
    /// - Parameters:
    ///   - taskID: Task identifier for pages increment
    ///   - marker: Update identifier
    func remove(taskID: Int, marker: String) -> SSUpdate
}

/// Protocol with requirements to react on Task related updates
/// - Note:
/// Default implementation for super protocol `SSUpdateReceiver` provided in extension. It's map Task's updates titles to methods and provide them as reactions. Any object implementing this protocol may not implement `SSUpdateReceiver` methods (like 'reactions()') but has implements methods declared inside this protocol. It's easy way to add `TaskUpdateReceiver` functional to any class.
internal protocol SSUETaskUpdateReceiver: SSUpdateReceiver {
    /// Reaction on Task's pages did increment
    /// - Parameters:
    ///   - taskID: Task identifier
    ///   - marker: Update identifier
    func taskDidIncrementPages(taskID: Int, marker: String?)
    
    /// Reaction on Task did rename
    /// - Parameters:
    ///   - taskID: Task identifier
    ///   - title: New Task title
    ///   - marker: Update identifier
    func taskDidRename(taskID: Int, title: String, marker: String?)
    
    /// Reaction on Task did remove
    /// - Parameters:
    ///   - taskID: Task identifier
    ///   - marker: Update identifier
    func taskDidRemove(taskID: Int, marker: String?)
}

/// Helper that store title and arg keys for Task's Updates
internal struct SSUETaskUpdateNotifications {
    internal static var incrementPages = (name: "task_did_increment_pages", taskID: "task_id")
    internal static var rename = (name: "task_did_rename", taskID: "task_id", title: "title")
    internal static var remove = (name: "task_did_remove", taskID: "task_id")
}

/// Sync api for task obtain.
/// It may be Storage proxing.
internal protocol SSUETaskApi {
    func getTask(taskID: Int) -> SSUETask?
    func getTasks(bookID: Int) -> [SSUETask]
}

/// Sync api for task altering.
/// It may be Storage proxing.
internal protocol SSUETaskEditApi {
    func renameTask(taskID: Int, title: String) throws
    func removeTask(taskID: Int) throws
    func incrementPages(taskID: Int) throws
}

/// Async api for task altering.
/// It may be Network proxing.
internal protocol SSUETaskEditAsyncApi {
    func renameTask(taskID: Int, title: String, marker: String, handler: @escaping (Error?)->Void)
    func removeTask(taskID: Int, marker: String, handler: @escaping (Error?)->Void)
    func incrementPages(taskID: Int, marker: String, handler: @escaping (Error?)->Void)
}

extension SSUETaskUpdate {
    internal func incrementPages(taskID: Int, marker: String) -> SSUpdate {
        let keys = SSUETaskUpdateNotifications.incrementPages
        return SSUpdate(name: keys.name, marker: marker, args: [keys.taskID : taskID])
    }
    
    internal func rename(taskID: Int, title: String, marker: String) -> SSUpdate {
        let keys = SSUETaskUpdateNotifications.rename
        return SSUpdate(name: keys.name, marker:marker, args: [keys.taskID : taskID, keys.title : title])
    }
    
    internal func remove(taskID: Int, marker: String) -> SSUpdate {
        let keys = SSUETaskUpdateNotifications.remove
        return SSUpdate(name: keys.name, marker:marker, args: [keys.taskID : taskID])
    }
}

extension SSUETaskUpdateReceiver {
    public func reactions() -> SSUpdate.ReactionMap {
        return taskReactions()
    }
    
    internal func taskReactions() -> SSUpdate.ReactionMap {
        return [SSUETaskUpdateNotifications.incrementPages.name : taskDidIncrementPages(_:),
                SSUETaskUpdateNotifications.rename.name : taskDidRename(_:),
                SSUETaskUpdateNotifications.remove.name : taskDidRemove(_:)]
    }
    
    private func taskDidIncrementPages(_ update: SSUpdate) {
        let keys = SSUETaskUpdateNotifications.incrementPages
        taskDidIncrementPages(taskID: update.args[keys.taskID] as! Int, marker: update.marker)
    }
    
    private func taskDidRename(_ update: SSUpdate) {
        let keys = SSUETaskUpdateNotifications.rename
        taskDidRename(taskID: update.args[keys.taskID] as! Int, title: update.args[keys.title] as! String, marker: update.marker)
    }
    
    private func taskDidRemove(_ update: SSUpdate) {
        let keys = SSUETaskUpdateNotifications.remove
        taskDidRemove(taskID: update.args[keys.taskID] as! Int, marker: update.marker)
    }
}
