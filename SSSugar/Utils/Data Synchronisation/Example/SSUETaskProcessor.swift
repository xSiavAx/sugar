import Foundation

/// Task obtainer.
///
/// # COnfroms to:
/// `SSEntityObtainer`
internal class SSUETaskObtainer {
    /// Obtaining task's id
    var taskID: Int
    /// Task Data Api
    var api: SSUETaskApi
    
    /// Creates new Obtainer
    /// - Parameters:
    ///   - taskID: Obtaining task's id
    ///   - api: Task Data Api
    public init(taskID mTaskID: Int, api mApi: SSUETaskApi) {
        taskID = mTaskID
        api = mApi
    }
}

extension SSUETaskObtainer: SSEntityObtainer {
    public func obtain() -> SSUETask? {
        return api.getTask(taskID: taskID)
    }
}

/// Task processor.
///
/// Uses `SSUETaskObtainer` as obtainer, `SSUETaskUpdater` as updater, `SSUETaskDBMutator` as mutator.
///
/// - Note: Entity's type should be provided exp;icitly (`typealias Entity = SSUETask`) and can't be obtained by entity property type (Looks like it's swift's bug).
///
/// # Confroms to:
/// `SSUETaskSource`, `SSSingleEntityProcessing`.
internal class SSUETaskProcessor<UpdateDelegate: SSUETaskUpdaterDelegate> {
    typealias Entity = SSUETask
    
    var entity: SSUETask?
    let executor: SSExecutor
    let obtainer: SSUETaskObtainer
    private(set) var updater: SSUETaskUpdater<SSUETaskProcessor, UpdateDelegate>?
    private(set) var mutator: SSUETaskDBMutator<SSUETaskProcessor>?
    let updateCenter: SSUpdateCenter
    weak var updateDelegate: UpdateDelegate?
    
    /// Task api passed to obtainer and mutator.
    let taskApi: SSUETaskApi & SSUETaskEditApi
    
    /// Creates new Task Processor
    /// - Parameters:
    ///   - taskID: Identifier of task to process.
    ///   - taskApi: Task API to pass obtainer and mutator.
    ///   - executor: BG tasks executor.
    ///   - updateCenter: Update center.
    public init(taskID: Int, taskApi mTaskApi: SSUETaskApi & SSUETaskEditApi, mExecutor: SSExecutor, updateCenter mUpdateCenter: SSUpdateCenter) {
        taskApi = mTaskApi
        executor = mExecutor
        updateCenter = mUpdateCenter
        obtainer = SSUETaskObtainer(taskID: taskID, api: taskApi)
    }
}

extension SSUETaskProcessor: SSUETaskSource {}

extension SSUETaskProcessor: SSSingleEntityProcessing {
    func createUpdaterAndMutator() {
        updater = SSUETaskUpdater(receiversManager: updateCenter)
        mutator = SSUETaskDBMutator(api: taskApi, executor: executor, notifier: updateCenter)
    }
}
