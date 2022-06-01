import Foundation
import SSSugarCore

//MARK: - Task base

/// Errors may occur in `SSUETaskDMCore` and it's inheritors
enum SSUETaskDMCoreError: Error {
    /// Core has invalid data
    case invalidData
    /// Limit reached
    case limitReached
}

/// Base class for Task Modify Core.
///
/// # Confroms to:
/// `SSCopying`, `SSUETaskUpdate`, `SSMarkerGenerating`, `Hashable`, `SSEquatable`
internal class SSUETaskDMCore: SSCopying, SSUETaskUpdate, SSMarkerGenerating, Hashable, SSEquatable {
    /// Modyfing task's id
    internal let taskID: Int
    
    /// Creates new Task Core with passed task's id
    /// - Parameter taskID: Modyfing task's id
    internal init(taskID mTaskID: Int) {
        taskID = mTaskID
    }
    
    /// Creates new Task Core based on passed one
    /// - Parameter other: Task Core to create new one based on
    internal required init(copy other: SSUETaskDMCore) {
        let mChange = other as! Self

        taskID = mChange.taskID
    }
    
    /// Returns, should core be adapted to passed one.
    /// - Parameter core: Core to adapt to.
    /// - Important: Protected, for internal purposes only.
    internal func shouldAdapt(to core: SSUETaskDMCore) -> Bool {
        return taskID == core.taskID
    }
    
    //MARK: Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(taskID)
    }
    
    //MARK: SSEquatable
    
    func isSameProps(with other: SSUETaskDMCore) -> Bool {
        return taskID == other.taskID
    }
    
    func isSameType(with other: SSUETaskDMCore) -> Bool {
        return true
    }
}

//MARK: - Increment pages

/// Task pages incrementation Data Modify Core
///
/// # Extedns:
/// `SSUETaskDMCore`
///
/// # Confroms to:
/// * `SSDataModifyCore`, `SSInheritedEquatable`
internal class SSUETaskIncrementPagesDmCore: SSUETaskDMCore, SSInheritedEquatable {
    /// Anscestor type for `InheritedEquatble`
    typealias Ancestor = SSUETaskDMCore
    
    /// Task's pages previous count.
    internal private(set) var prevPages: Int?
    
    /// Creates new Task incrementation DM Core
    /// - Parameters:
    ///   - taskID: Identifier of incrementation pages task.
    ///   - prevPages: Previous pages count of incrementation pages task.
    internal init(taskID: Int, prevPages mPrevPages: Int?) {
        prevPages = mPrevPages
        super.init(taskID: taskID)
    }
    
    /// Creates new Task incrementation DM Core based on passed one
    /// - Parameter other: Task incrementation DM Core to create new one based on.
    internal required init(copy other: SSUETaskDMCore) {
        let mChange = other as! Self

        prevPages = mChange.prevPages
        super.init(copy: other)
    }
    
    func incrementPrevPages() throws {
        guard let mPrevPages = prevPages else { throw SSUETaskDMCoreError.invalidData }
        guard mPrevPages < SSUETask.maxPages else { throw SSUETaskDMCoreError.limitReached }
        
        prevPages! += 1
    }
    
    //MARK: Override
    
    override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        hasher.combine(prevPages)
    }
    
    override func isSameType(with other: SSUETaskDMCore) -> Bool {
        return isAncestorSameType(other)
    }
    
    override func isSameProps(with other: SSUETaskDMCore) -> Bool {
        return cast(other) { prevPages == $0.prevPages }
    }
}

extension SSUETaskIncrementPagesDmCore: SSDataModifyCore {
    func toUpdate() -> SSUpdate { incrementPages(taskID: taskID, marker: Self.newMarker()) }
}

//MARK: - Rename

/// Task renaming Data Modify Core
///
/// # Extedns:
/// `SSUETaskDMCore`
///
/// # Confroms to:
/// * `SSDataModifyCore`, `SSInheritedEquatable`
internal class SSUETaskRenameDmCore: SSUETaskDMCore, SSInheritedEquatable {
    /// Anscestor type for `InheritedEquatble`
    typealias Ancestor = SSUETaskDMCore
    
    /// Renaming task's new title
    internal let taskTitle: String
    
    /// Creates new Task renaming DM Core
    /// - Parameters:
    ///   - taskID: Renaming task's id
    ///   - taskTitle: Renaming task's new title value
    internal init(taskID: Int, taskTitle mTaskTitle: String) {
        taskTitle = mTaskTitle
        super.init(taskID: taskID)
    }
    
    /// Creates new Task renaming DM Core based on passed one.
    /// - Parameter other: Task renaming DM Core to create new one based on.
    internal required init(copy other: SSUETaskDMCore) {
        let mChange = other as! Self

        taskTitle = mChange.taskTitle
        super.init(copy: other)
    }
    
    //MARK: Override
    
    override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        hasher.combine(taskTitle)
    }
    
    override func isSameType(with other: SSUETaskDMCore) -> Bool {
        return isAncestorSameType(other)
    }
    
    override func isSameProps(with other: SSUETaskDMCore) -> Bool {
        return cast(other) { taskTitle == $0.taskTitle }
    }
}

extension SSUETaskRenameDmCore: SSDataModifyCore {
    func toUpdate() -> SSUpdate { rename(taskID: taskID, title: taskTitle, marker: Self.newMarker()) }
}

//MARK: - Remove

/// Task removing Data Modify Core
///
/// # Extedns:
/// `SSUETaskDMCore`
///
/// # Confroms to:
/// * `SSDataModifyCore`
internal class SSUETaskRemoveDmCore: SSUETaskDMCore {}

extension SSUETaskRemoveDmCore: SSDataModifyCore {
    func toUpdate() -> SSUpdate { remove(taskID: taskID, marker: Self.newMarker()) }
}
