import Foundation

internal protocol SSUETaskChangeAdapting {
    func adaptByIncrementPages(change: SSUETaskIncrementPagesChange) -> SSDmToChangeAdaptResult
    func adaptByRename(change: SSUETaskRenameChange) -> SSDmToChangeAdaptResult
    func adaptByRemove(change: SSUETaskRemoveChange) -> SSDmToChangeAdaptResult
}

internal protocol SSUETaskModify: SSDataModifying, SSUETaskUpdate, SSMarkerGenerating {
    var taskID: Int { get }
}

internal protocol SSUETaskIncrementPagesModify: SSUETaskModify {
    var prevPages: Int? { get }
}

internal protocol SSUETaskRenameModify: SSUETaskModify {
    var taskTitle: String { get }
}

internal protocol SSUETaskRemoveModify: SSUETaskModify {}

extension SSUETaskIncrementPagesModify {
    func toUpdate() -> SSUpdate { incrementPages(taskID: taskID, marker: Self.newMarker()) }
}

extension SSUETaskRenameModify {
    func toUpdate() -> SSUpdate { rename(taskID: taskID, title: taskTitle, marker: Self.newMarker()) }
}

extension SSUETaskRemoveModify {
    func toUpdate() -> SSUpdate { remove(taskID: taskID, marker: Self.newMarker()) }
}

internal class SSUETaskChange: SSUEChange {
    internal let taskID: Int

    internal init(taskID mTaskID: Int) {
        taskID = mTaskID
        super.init()
    }

    internal required init(copy other: SSUEChange) {
        let mChange = other as! Self

        taskID = mChange.taskID
        super.init(copy: other)
    }
}

internal class SSUETaskIncrementPagesChange: SSUETaskChange, SSUETaskIncrementPagesModify {
    internal let prevPages: Int?

    internal init(taskID: Int, prevPages mPrevPages: Int? = nil) {
        prevPages = mPrevPages
        super.init(taskID: taskID)
    }

    internal required init(copy other: SSUEChange) {
        let mChange = other as! Self

        prevPages = mChange.prevPages
        super.init(copy: other)
    }
}

extension SSUETaskIncrementPagesChange: SSDmFinalChange {
    static var title: String = "task_pages_incremented"
}

internal class SSUETaskRenameChange: SSUETaskChange, SSUETaskRenameModify {
    internal let taskTitle: String

    internal init(taskID: Int, taskTitle mTaskTitle: String) {
        taskTitle = mTaskTitle
        super.init(taskID: taskID)
    }

    internal required init(copy other: SSUEChange) {
        let mChange = other as! SSUETaskRenameChange

        taskTitle = mChange.taskTitle
        super.init(copy: other)
    }
}

extension SSUETaskRenameChange: SSDmFinalChange {
    internal static var title = "task_renamed"
}

internal class SSUETaskRemoveChange: SSUETaskChange, SSUETaskRemoveModify, SSDmFinalChange {
    internal static var title = "task_removed"
}

internal class SSUETaskRequest: SSUERequest {
    internal let taskID: Int

    internal init(taskID mTaskID: Int) {
        taskID = mTaskID
        super.init()
    }

    internal required init(copy other: SSUERequest) {
        let mChange = other as! Self

        taskID = mChange.taskID
        super.init(copy: other)
    }
}

internal class SSUETaskIncrementPagesRequest: SSUETaskRequest, SSUETaskIncrementPagesModify {
    internal let prevPages: Int?

    internal init(taskID: Int, prevPages mPrevPages: Int? = nil) {
        prevPages = mPrevPages
        super.init(taskID: taskID)
    }

    internal required init(copy other: SSUERequest) {
        let mChange = other as! Self

        prevPages = mChange.prevPages
        super.init(copy: other)
    }
}

extension SSUETaskIncrementPagesRequest: SSDmFinalRequest {
    static var title: String = "task/pages_increment"
}

internal class SSUETaskRenameRequest: SSUETaskRequest, SSUETaskRenameModify {
    internal let taskTitle: String

    internal init(taskID: Int, taskTitle mTaskTitle: String) {
        taskTitle = mTaskTitle
        super.init(taskID: taskID)
    }

    internal required init(copy other: SSUERequest) {
        let mChange = other as! Self

        taskTitle = mChange.taskTitle
        super.init(copy: other)
    }
}

extension SSUETaskRenameRequest: SSDmFinalRequest {
    internal static var title = "task/rename"
}

internal class SSUETaskRemoveRequest: SSUETaskRequest, SSUETaskRemoveModify, SSDmFinalRequest {
    internal static var title = "task_removed"
}
