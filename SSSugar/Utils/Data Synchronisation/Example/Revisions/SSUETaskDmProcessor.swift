import Foundation

internal class SSUETaskDmProcessor<UpdateDelegate: SSUETaskUpdaterDelegate, Dispatcher: SSDmRequestDispatcher>
where Dispatcher.Request == SSUEModify {
    typealias Entity = SSUETask
    
    private(set) var entity: SSUETask?
    let executor: SSExecutor
    let obtainer: SSUETaskObtainer
    private(set) var updater: SSUETaskUpdater<SSUETaskDmProcessor, UpdateDelegate>?
    private(set) var mutator: SSUETaskDmMutator<SSUETaskDmProcessor, Dispatcher>?
    let updateCenter: SSUpdateCenter
    let dispatcher: Dispatcher
    weak var updateDelegate: UpdateDelegate?
    
    public init(taskID: Int, taskApi: SSUETaskApi, mExecutor: SSExecutor, dispatcher mDispatcher: Dispatcher, updateCenter mUpdateCenter: SSUpdateCenter) {
        updateCenter = mUpdateCenter
        dispatcher = mDispatcher
        executor = mExecutor
        obtainer = SSUETaskObtainer(taskID: taskID, api: taskApi)
    }
}

extension SSUETaskDmProcessor: SSUETaskSource {}

extension SSUETaskDmProcessor: SSSingleEntityProcessing {
    func createUpdaterAndMutator() {
        updater = SSUETaskUpdater(receiversManager: updateCenter)
        mutator = SSUETaskDmMutator(requestDispatcher: dispatcher)
    }
    
    func assign(entity mEntity: Entity) {
        entity = mEntity
    }
}

