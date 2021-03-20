import Foundation

/// Requirements for core of all modifycations.
///
/// Base implementation should incapsulate Update creation logic (`toUpdate() -> SSUpdate`), but class that implements `SSDataModifyCore` or class hierarchy that finally implements `SSDataModifyCore` may contain entity related logic (what store? how create and copy? how check or alter? etc.)
/// It used as part of `SSDataModifying` to add ability of incapsulation common entity related logic of Change and Request into class and it's inheritinace. (See `SSUETaskDMCore`, `SSUETaskIncrementPagesDmCore`, `SSUETaskRenameDmCore`, `SSUETaskRemoveDmCore` and `SSUETaskIncrementPagesChange`, `SSUETaskRenameChange`, `SSUETaskRemoveChange`, `SSUETaskIncrementPagesRequest`, `SSUETaskRenameRequest` `SSUETaskRemoveRequest` examples).
///
/// Entity related logic can't be added directly to Change or Request due to multiple inheritance problem – any concreate Change and Request should be inherited from Base Change and Request coresponding, but also they have common logic (entity related) that can't be inherited too. This problem may be resolved by extensions, but it requires repeating large amount of common code that cannot be declared in extension (like properties, initializing, copying) in every modify class pair (Change and Request).
public protocol SSDataModifyCore {
    /// Creates update
    /// - Returns: Update.
    func toUpdate() -> SSUpdate
}

/// Requierements for any data modification that used inside Revisions synchronisation system.
/// Extends `SSCopying`.
public protocol SSDataModifying: SSCopying {
    /// Modification core
    var core: SSDataModifyCore {get}
    /// Modification title that identify it. Should be unique via all modifications.
    var title: String {get}
}

extension SSDataModifying {
    /// Creates update via core call proxing.
    /// - Returns: Update.
    func toUpdate() -> SSUpdate {
        core.toUpdate()
    }
}

/// Requirements for final Change class
public protocol SSDmChange: SSDataModifying {
    /// Modification title
    static var title: String {get}
}

/// Requirements for final Request class
public protocol SSDmRequest: SSDataModifying {
    /// Modification title
    static var title: String {get}
}

/// Base modification class. Class should be used any way execept for concretisastion generics of related classes. See `SSUERevision`, `SSUEBatch`, `SSUETaskDmProcessor`, `SSUETaskDmMutator`, `SSUETaskBatchApplier`.
///
/// Implements core property.
/// For inheritance purpouses use `SSCoredModify` class.
/// - Warning: Copying and title property should be implemented by inheritors.
open class SSModify: SSDataModifying {
    /// Modification's core
    public var core: SSDataModifyCore
    /// Modification's title
    open var title: String { fatalError("Not implemented") }

    /// Creates new Modification.
    /// - Parameter core: Modifycation core.
    public init(core mCore: SSDataModifyCore) {
        core = mCore
    }

    /// Creates new Modification based on other one.
    /// - Parameter other: Modification to create new one with.
    /// - Warning: Should be implemented by inheritor.
    public required init(copy other: SSModify) {
        fatalError("Not implemented")
    }
}

/// Base modification class with Generic type for Core.
///
/// Implements core acess, creating, copying. See `SSUEChange` and `SSUERequest` (and their inheritors) for examples.
/// - Warning: Title property should be implemented by inheritors.
open class SSCoredModify<Core: SSDataModifyCore&SSCopying>: SSModify {
    /// Concretized core
    public var iCore: Core { core as! Core }

    /// Creates new Modification.
    /// - Parameter core: Modifycation core.
    public init(core: Core) {
        super.init(core: core)
    }

    /// Creates new Modification based on other one.
    /// - Parameter other: Modification to create new one with.
    public required init(copy other: SSModify) {
        let mOther = other as! Self
        super.init(core: mOther.iCore.copy())
    }
}

