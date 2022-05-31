import Foundation
import SSSugarCore

extension SSUERequest where Core: SSUETaskDMCore {
    func shouldAdapt<ChCore: SSUETaskDMCore>(to change: SSUEChange<ChCore>) -> Bool {
        return iCore.shouldAdapt(to: change.iCore)
    }
    
    func adaptByRemove(change: SSUETaskRemoveChange) -> SSDmToChangeAdaptResult {
        return shouldAdapt(to: change) ? .canceled : .passed
    }
}

/// Increment task pages request
///
/// Usees `SSUETaskIncrementPagesDmCore` as core
///
/// # Inherited from:
/// `SSUERequest`
///
/// # Conforms to:
/// `SSDmRequest`, `SSUETaskChangeAdapting`
internal class SSUETaskIncrementPagesRequest: SSUERequest<SSUETaskIncrementPagesDmCore> {
    /// Increment task pages request's title
    override var title: String {Self.title}
    
    /// Creates new Increment task pages request
    /// - Parameters:
    ///   - taskID: Identifier of incrementation pages task.
    ///   - prevPages: Previous pages count of incrementation pages task.
    internal init(taskID: Int, prevPages: Int? = nil) {
        super.init(core: SSUETaskIncrementPagesDmCore(taskID: taskID, prevPages: prevPages))
    }
    
    /// Creates new Increment task pages request based on passed one
    /// - Parameter other: Increment task pages request to create new one based on
    internal required init(copy other: SSModify) {
        super.init(copy: other)
    }
}

extension SSUETaskIncrementPagesRequest: SSDmRequest {
    /// Increment task pages request's title
    static var title: String = "task/pages_increment"
}

extension SSUETaskIncrementPagesRequest: SSUETaskChangeAdapting {
    /// Adapts args by Increment task pages Change
    /// - Parameter change: Increment task pages Change to adapt to
    /// - Returns: Adaptation result
    /// If task's `id` is same increments previous pages count or retunr `.canceled`
    func adaptByIncrementPages(change: SSUETaskIncrementPagesChange) -> SSDmToChangeAdaptResult {
        if (shouldAdapt(to: change)) {
            do {
                try iCore.incrementPrevPages()
            } catch (SSUETaskDMCoreError.limitReached) {
                return .canceled
            } catch {
                fatalError("Unexpected error \(error)")
            }
        }
        return .passed
    }
    
    /// Adapts args by Rename task Change
    /// - Parameter change: Rename task Change to adapt to
    /// - Returns: `.passed`
    func adaptByRename(change: SSUETaskRenameChange) -> SSDmToChangeAdaptResult {
        return .passed
    }
}

/// Rename task request
///
/// Usees `SSUETaskRenameDmCore` as core
///
/// # Inherited from:
/// `SSUERequest`
///
/// # Conforms to:
/// `SSDmRequest`, `SSUETaskChangeAdapting`
internal class SSUETaskRenameRequest: SSUERequest<SSUETaskRenameDmCore> {
    /// Rename task request's title
    override var title: String {Self.title}
    
    /// Creates new Rename task request
    /// - Parameters:
    ///   - taskID: Renaming task's id
    ///   - taskTitle: New task title
    internal init(taskID: Int, taskTitle: String) {
        super.init(core: SSUETaskRenameDmCore(taskID: taskID, taskTitle: taskTitle))
    }

    /// Creates new Rename task request based on passed one
    /// - Parameter other: Rename task request to create new one based on
    internal required init(copy other: SSModify) {
        super.init(copy: other)
    }
}

extension SSUETaskRenameRequest: SSDmRequest {
    /// Rename task request's title
    internal static var title = "task/rename"
}

extension SSUETaskRenameRequest: SSUETaskChangeAdapting {
    /// Adapts args by Increment task pages Change
    /// - Parameter change: Increment task pages Change to adapt to
    /// - Returns: `.passed`
    func adaptByIncrementPages(change: SSUETaskIncrementPagesChange) -> SSDmToChangeAdaptResult {
        return .passed
    }
    
    /// Adapts args by Rename task Change
    /// - Parameter change: Rename task Change to adapt to
    /// - Returns: `.passed`
    func adaptByRename(change: SSUETaskRenameChange) -> SSDmToChangeAdaptResult {
        return .passed
    }
}

/// Remove task request
///
/// Usees `SSUETaskRemoveDmCore` as core
///
/// # Inherited from:
/// `SSUERequest`
///
/// # Conforms to:
/// `SSDmRequest`, `SSUETaskChangeAdapting`
internal class SSUETaskRemoveRequest: SSUERequest<SSUETaskRemoveDmCore> {
    /// Remove task request's title
    override var title: String {Self.title}
    
    /// Creates new Remove task request
    /// - Parameter taskID: Removing task's id
    internal init(taskID: Int) {
        super.init(core: SSUETaskRemoveDmCore(taskID: taskID))
    }

    /// Creates new Remove task request based on passed one
    /// - Parameter other: Remove task request to create new one based on
    internal required init(copy other: SSModify) {
        super.init(copy: other)
    }
}

extension SSUETaskRemoveRequest: SSDmRequest {
    /// Remove task request's title
    internal static var title = "task/remove"
}

extension SSUETaskRemoveRequest: SSUETaskChangeAdapting {
    /// Adapts args by Increment task pages Change
    /// - Parameter change: Increment task pages Change to adapt to
    /// - Returns: `.passed`
    func adaptByIncrementPages(change: SSUETaskIncrementPagesChange) -> SSDmToChangeAdaptResult {
        return .passed
    }
    
    /// Adapts args by Rename task Change
    /// - Parameter change: Rename task Change to adapt to
    /// - Returns: `.passed`
    func adaptByRename(change: SSUETaskRenameChange) -> SSDmToChangeAdaptResult {
        return .passed
    }
}
