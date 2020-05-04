import Foundation

internal class SSUEChange<Core: SSDataModifyCore&SSCopying>: SSCoredModify<Core> {
    // Change related logic
}

internal class SSUERequest<Core: SSDataModifyCore&SSCopying>: SSCoredModify<Core> {
    // Request related logic
}

typealias SSUERevision = SSDmRevision<SSModify>
typealias SSUEBatch = SSDmBatch<SSModify>
