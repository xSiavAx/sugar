import Foundation

internal protocol SSUETaskChangeAdapting {
    func adaptByIncrementPages(change: SSUETaskIncrementPagesChange) -> SSDmToChangeAdaptResult
    func adaptByRename(change: SSUETaskRenameChange) -> SSDmToChangeAdaptResult
    func adaptByRemove(change: SSUETaskRemoveChange) -> SSDmToChangeAdaptResult
}

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
