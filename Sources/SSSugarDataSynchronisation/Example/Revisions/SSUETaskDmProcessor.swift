import Foundation
import SSSugarExecutors

/// Task processor working with TaskDMMutator.
///
/// Uses `SSUETaskObtainer` as obtainer, `SSUETaskUpdater` as updater, `SSUETaskDmMutator` as mutator.
///
/// - Note: Entity's type should be provided explicitly (`typealias Entity = SSUETask`) and can't be obtained by entity property type (Looks like it's swift's bug).
///
/// # Confroms to:
/// `SSUETaskSource`, `SSSingleEntityProcessing`.
internal class SSUETaskDmProcessor<UpdateDelegate: SSUETaskUpdaterDelegate, Dispatcher: SSDmRequestDispatcher>
where Dispatcher.Request == SSModify {
    typealias Entity = SSUETask
    
    var entity: SSUETask?
    let executor: SSExecutor
    let obtainer: SSUETaskObtainer
    private(set) var updater: SSUETaskUpdater<SSUETaskDmProcessor, UpdateDelegate>?
    private(set) var mutator: SSUETaskDmMutator<SSUETaskDmProcessor, Dispatcher>?
    let updateCenter: SSUpdateCenter
    let dispatcher: Dispatcher
    weak var updateDelegate: UpdateDelegate?
    
    /// Creates new Task Processor
    /// - Parameters:
    ///   - taskID: Identifier of task to process.
    ///   - taskApi: Task API to pass to obtainer
    ///   - executor: BG tasks executor.
    ///   - dispatcher: Requests dispatcher.
    ///   - updateCenter: Update center.
    internal init(taskID: Int, taskApi: SSUETaskApi, executor mExecutor: SSExecutor, dispatcher mDispatcher: Dispatcher, updateCenter mUpdateCenter: SSUpdateCenter) {
        updateCenter = mUpdateCenter
        dispatcher = mDispatcher
        executor = mExecutor
        obtainer = SSUETaskObtainer(taskID: taskID, api: taskApi)
    }
}

extension SSUETaskDmProcessor: SSUETaskSource {}

extension SSUETaskDmProcessor: SSSingleEntityProcessing {
    func createUpdaterAndMutator() {
        let mUpdater = SSUETaskUpdater(receiversManager: updateCenter, source: self, delegate: updateDelegate!)
        let mMutator = SSUETaskDmMutator(requestDispatcher: dispatcher, source: self)
        
        updater = mUpdater
        mutator = mMutator
    }
}

