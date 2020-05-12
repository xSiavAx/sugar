import Foundation

/// Data modify Change
///
/// # Inherited from:
/// `SSCoredModify`
internal class SSUEChange<Core: SSDataModifyCore&SSCopying>: SSCoredModify<Core> {
    // Project specific Change related logic
}

/// Data modify Request
///
/// # Task related extension
/// For `SSUETaskDMCore` has extension with adapt helping methods. See `SSUERequests`.
///
/// # Inherited from:
/// `SSCoredModify`
internal class SSUERequest<Core: SSDataModifyCore&SSCopying>: SSCoredModify<Core> {
    // Project specific Request related logic
}

/// Data modify Revision Type
typealias SSUERevision = SSDmRevision<SSModify>

/// Data modify requests Bacth Type
typealias SSUEBatch = SSDmBatch<SSModify>
