import Foundation

//MARK: - Task base

internal class SSUETaskDMCore: SSCopying, SSUETaskUpdate, SSMarkerGenerating {
    internal let taskID: Int

    internal init(taskID mTaskID: Int) {
        taskID = mTaskID
    }

    internal required init(copy other: SSUETaskDMCore) {
        let mChange = other as! Self

        taskID = mChange.taskID
    }
    
    func shouldAdapt(to core: SSUETaskDMCore) -> Bool {
        return taskID == core.taskID
    }
}

//MARK: - Increment pages

internal class SSUETaskIncrementPagesDmCore: SSUETaskDMCore {
    internal let prevPages: Int?

    internal init(taskID: Int, prevPages mPrevPages: Int?) {
        prevPages = mPrevPages
        super.init(taskID: taskID)
    }

    internal required init(copy other: SSUETaskDMCore) {
        let mChange = other as! Self

        prevPages = mChange.prevPages
        super.init(copy: other)
    }
}

extension SSUETaskIncrementPagesDmCore: SSDataModifyCore {
    func toUpdate() -> SSUpdate { incrementPages(taskID: taskID, marker: Self.newMarker()) }
}

//MARK: - Rename

internal class SSUETaskRenameDmCore: SSUETaskDMCore {
    internal let taskTitle: String

    internal init(taskID: Int, taskTitle mTaskTitle: String) {
        taskTitle = mTaskTitle
        super.init(taskID: taskID)
    }

    internal required init(copy other: SSUETaskDMCore) {
        let mChange = other as! Self

        taskTitle = mChange.taskTitle
        super.init(copy: other)
    }
}

extension SSUETaskRenameDmCore: SSDataModifyCore {
    func toUpdate() -> SSUpdate { rename(taskID: taskID, title: taskTitle, marker: Self.newMarker()) }
}

//MARK: - Remove

internal class SSUETaskRemoveDmCore: SSUETaskDMCore {}

extension SSUETaskRemoveDmCore: SSDataModifyCore {
    func toUpdate() -> SSUpdate { remove(taskID: taskID, marker: Self.newMarker()) }
}
