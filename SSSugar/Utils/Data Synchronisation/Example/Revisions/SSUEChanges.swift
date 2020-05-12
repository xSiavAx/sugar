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

/// Task increment pages change
///
/// Usees `SSUETaskIncrementPagesDmCore` as core
///
/// # Inherited from:
/// `SSUEChange`
/// # Conforms to:
/// `SSDmChange`
internal class SSUETaskIncrementPagesChange: SSUEChange<SSUETaskIncrementPagesDmCore> {
    override var title: String {Self.title}
    
    internal init(taskID: Int, prevPages: Int? = nil) {
        super.init(core: SSUETaskIncrementPagesDmCore(taskID: taskID, prevPages: prevPages))
    }
    
    internal required init(copy other: SSModify) {
        super.init(copy: other)
    }
}

extension SSUETaskIncrementPagesChange: SSDmChange {
    static var title: String = "task_pages_incremented"
}

/// Task rename change
///
/// Usees `SSUETaskRenameDmCore` as core
///
/// # Inherited from:
/// `SSUEChange`
/// # Conforms to:
/// `SSDmChange`
internal class SSUETaskRenameChange: SSUEChange<SSUETaskRenameDmCore> {
    override var title: String {Self.title}
    
    internal init(taskID: Int, taskTitle: String) {
        super.init(core: SSUETaskRenameDmCore(taskID: taskID, taskTitle: taskTitle))
    }

    internal required init(copy other: SSModify) {
        super.init(copy: other)
    }
}

extension SSUETaskRenameChange: SSDmChange {
    internal static var title = "task_renamed"
}

/// Task remove change
///
/// Usees `SSUETaskRemoveDmCore` as core
///
/// # Inherited from:
/// `SSUEChange`
/// # Conforms to:
/// `SSDmChange`
internal class SSUETaskRemoveChange: SSUEChange<SSUETaskRemoveDmCore> {
    override var title: String {Self.title}
    
    internal init(taskID: Int) {
        super.init(core: SSUETaskRemoveDmCore(taskID: taskID))
    }

    internal required init(copy other: SSModify) {
        super.init(copy: other)
    }
}

extension SSUETaskRemoveChange: SSDmChange {
    internal static var title = "task_removed"
}
