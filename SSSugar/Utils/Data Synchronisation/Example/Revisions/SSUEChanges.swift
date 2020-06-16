import Foundation

/// Requirenent for modification (usually request) that able adapts to Task changes.
internal protocol SSUETaskChangeAdapting {
    /// Adapts by passed Task increment pages change and returns adaptaion result
    /// - Parameter change: Adaptation result
    func adaptByIncrementPages(change: SSUETaskIncrementPagesChange) -> SSDmToChangeAdaptResult
    /// Adapts by passed Task rename change and returns adaptaion result
    /// - Parameter change: Adaptation result
    func adaptByRename(change: SSUETaskRenameChange) -> SSDmToChangeAdaptResult
    /// Adapts by passed Task remove change and returns adaptaion result
    /// - Parameter change: Adaptation result
    func adaptByRemove(change: SSUETaskRemoveChange) -> SSDmToChangeAdaptResult
}

/// Increment task pages change
///
/// Usees `SSUETaskIncrementPagesDmCore` as core
///
/// # Inherited from:
/// `SSUEChange`
///
/// # Conforms to:
/// `SSDmChange`
internal class SSUETaskIncrementPagesChange: SSUEChange<SSUETaskIncrementPagesDmCore> {
    /// Increment task pages change's title
    override var title: String {Self.title}
    
    /// Creates new Increment task pages change
    /// - Parameters:
    ///   - taskID: Identifier of incrementation pages task.
    ///   - prevPages: Previous pages count of incrementation pages task.
    internal init(taskID: Int, prevPages: Int? = nil) {
        super.init(core: SSUETaskIncrementPagesDmCore(taskID: taskID, prevPages: prevPages))
    }
    
    /// Creates new Increment task pages change based on passed one
    /// - Parameter other: Increment task pages change to create new one based on
    internal required init(copy other: SSModify) {
        super.init(copy: other)
    }
}

extension SSUETaskIncrementPagesChange: SSDmChange {
    /// Increment task pages change's title
    static var title: String = "task_pages_incremented"
}

/// Rename task change
///
/// Usees `SSUETaskRenameDmCore` as core
///
/// # Inherited from:
/// `SSUEChange`
///
/// # Conforms to:
/// `SSDmChange`
internal class SSUETaskRenameChange: SSUEChange<SSUETaskRenameDmCore> {
    /// Rename task change's title
    override var title: String {Self.title}
    
    /// Creates new Rename task change
    /// - Parameters:
    ///   - taskID: Renaming task's id
    ///   - taskTitle: New task title
    internal init(taskID: Int, taskTitle: String) {
        super.init(core: SSUETaskRenameDmCore(taskID: taskID, taskTitle: taskTitle))
    }

    /// Creates new Rename task change based on passed one
    /// - Parameter other: Rename task change to create new one based on
    internal required init(copy other: SSModify) {
        super.init(copy: other)
    }
}

extension SSUETaskRenameChange: SSDmChange {
    /// Rename task change's title
    internal static var title = "task_renamed"
}

/// Remove task change
///
/// Usees `SSUETaskRemoveDmCore` as core
///
/// # Inherited from:
/// `SSUEChange`
///
/// # Conforms to:
/// `SSDmChange`
internal class SSUETaskRemoveChange: SSUEChange<SSUETaskRemoveDmCore> {
    /// Remove task change's title
    override var title: String {Self.title}
    
    /// Creates new Remove task change
    /// - Parameter taskID: Removing task's id
    internal init(taskID: Int) {
        super.init(core: SSUETaskRemoveDmCore(taskID: taskID))
    }

    /// Creates new Remove task change based on passed one
    /// - Parameter other: Remove task change to create new one based on
    internal required init(copy other: SSModify) {
        super.init(copy: other)
    }
}

extension SSUETaskRemoveChange: SSDmChange {
    /// Remove task change's title
    internal static var title = "task_removed"
}
