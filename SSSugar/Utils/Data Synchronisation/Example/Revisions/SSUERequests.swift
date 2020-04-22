import Foundation

extension SSUERequest where Core: SSUETaskDMCore {
    func shouldAdapt<ChCore: SSUETaskDMCore>(to change: SSUEChange<ChCore>) -> Bool {
        return iCore.shouldAdapt(to: change.iCore)
    }
    
    func adaptByRemove(change: SSUETaskRemoveChange) -> SSDmToChangeAdaptResult {
        return shouldAdapt(to: change) ? .canceled : .passed
    }
}

internal class SSUETaskIncrementPagesRequest: SSUERequest<SSUETaskIncrementPagesDmCore> {
    internal init(taskID: Int, prevPages: Int? = nil) {
        super.init(core: SSUETaskIncrementPagesDmCore(taskID: taskID, prevPages: prevPages))
    }
    
    internal required init(copy other: SSUEModify) {
        super.init(copy: other)
    }
}

extension SSUETaskIncrementPagesRequest: SSDmRequest {
    static var title: String = "task/pages_increment"
}

extension SSUETaskIncrementPagesRequest: SSUETaskChangeAdapting {
    func adaptByIncrementPages(change: SSUETaskIncrementPagesChange) -> SSDmToChangeAdaptResult {
        if (shouldAdapt(to: change)) {
            if (change.iCore.prevPages! == SSUETask.maxPages - 1) {
                return .canceled
            }
        }
        return .passed
    }
    
    func adaptByRename(change: SSUETaskRenameChange) -> SSDmToChangeAdaptResult {
        return .passed
    }
}

internal class SSUETaskRenameRequest: SSUERequest<SSUETaskRenameDmCore> {
    internal init(taskID: Int, taskTitle: String) {
        super.init(core: SSUETaskRenameDmCore(taskID: taskID, taskTitle: taskTitle))
    }

    internal required init(copy other: SSUEModify) {
        super.init(copy: other)
    }
}

extension SSUETaskRenameRequest: SSDmRequest {
    internal static var title = "task/rename"
}

extension SSUETaskRenameRequest: SSUETaskChangeAdapting {
    func adaptByIncrementPages(change: SSUETaskIncrementPagesChange) -> SSDmToChangeAdaptResult {
        return .passed
    }
    
    func adaptByRename(change: SSUETaskRenameChange) -> SSDmToChangeAdaptResult {
        return .passed
    }
}

internal class SSUETaskRemoveRequest: SSUERequest<SSUETaskRemoveDmCore> {
    internal init(taskID: Int, taskTitle mTaskTitle: String) {
        super.init(core: SSUETaskRemoveDmCore(taskID: taskID))
    }

    internal required init(copy other: SSUEModify) {
        super.init(copy: other)
    }
}

extension SSUETaskRemoveRequest: SSDmRequest {
    internal static var title = "task/remove"
}

extension SSUETaskRemoveRequest: SSUETaskChangeAdapting {
    func adaptByIncrementPages(change: SSUETaskIncrementPagesChange) -> SSDmToChangeAdaptResult {
        return .passed
    }
    
    func adaptByRename(change: SSUETaskRenameChange) -> SSDmToChangeAdaptResult {
        return .passed
    }
}
