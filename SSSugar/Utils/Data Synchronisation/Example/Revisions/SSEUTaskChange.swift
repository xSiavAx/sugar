import Foundation

internal class SSUETaskChange: SSUEChange, SSUETaskUpdate {
    internal let taskID: Int
    
    internal init(title: String, taskID mTaskID: Int) {
        taskID = mTaskID
        super.init(title: title)
    }
    
    internal required init(copy other: SSUEChange) {
        let taskCh = other as! SSUETaskChange
        
        taskID = taskCh.taskID
        super.init(copy: other)
    }
}

class SSEUTaskIncrementPagesChange: SSUETaskChange {
    static var title = "task_pages_incremented"
    var prevPages: Int

    init(prevPages: Int, taskID: Int) {
        <#code#>
    }

    required init(copy other: SSUETaskChange) {
        super.init(copy: other)
        prevPages = other.prevPages
        taskID = other.taskID
    }
}

