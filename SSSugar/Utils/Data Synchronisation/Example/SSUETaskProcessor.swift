import Foundation

internal class SSUETaskObtainer {
    var taskID: Int
    var api: SSUETaskApi
    
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

//TODO: Add to docs, that it's necessary to define 'Entity' type cuz swift's bug
internal class SSUETaskProcessor<UpdateDelegate: SSUETaskUpdaterDelegate> {
    typealias Entity = SSUETask
    
    private(set) var entity: SSUETask?
    let executor: SSExecutor
    let obtainer: SSUETaskObtainer
    private(set) var updater: SSUETaskUpdater<SSUETaskProcessor, UpdateDelegate>?
    private(set) var mutator: SSUETaskDBMutator<SSUETaskProcessor>?
    let updateCenter: SSUpdateCenter
    weak var updateDelegate: UpdateDelegate?
    
    let taskApi: SSUETaskApi & SSUETaskEditApi
    
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
    
    func assign(entity mEntity: Entity) {
        entity = mEntity
    }
}
