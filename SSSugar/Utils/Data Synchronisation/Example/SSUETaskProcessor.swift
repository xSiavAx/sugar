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

extension SSUETaskProcessor: SSSingleEntityProcessing {
    func createUpdaterAndMutator() {
        updater = SSUETaskUpdater(updateReceiversManager: updateCenter)
        mutator = SSUETaskDBMutator(api: taskApi, executor: executor, notifier: updateCenter)
    }
    
    func assign(entity mEntity: Entity) {
        entity = mEntity
    }
}

//Usage example

class DB {
    static var task : SSUETask? = SSUETask(taskID: 1, title: "Task 1", pages: 2)
}

class SSUETaskDBApi {}
extension SSUETaskDBApi: SSUETaskApi {
    func getTask(taskID: Int) -> SSUETask? {
        return DB.task
    }
    
    func getTasks(bookID: Int) -> [SSUETask] {
        return [DB.task!]
    }
}
extension SSUETaskDBApi: SSUETaskEditApi {
    func renameTask(taskID: Int, title: String) throws {
        DB.task?.title = title
    }
    
    func removeTask(taskID: Int) throws {
        DB.task = nil
    }
    
    func incrementPages(taskID: Int) throws {
        try DB.task?.incrementPages()
    }
}

class TaskView {
    var title: String
    var processor: SSUETaskProcessor<TaskView>
    
    init(title mTitle: String) {
        title = mTitle
        processor = SSUETaskProcessor(taskID: 1, taskApi: SSUETaskDBApi(), mExecutor: DispatchQueue.bg, updateCenter: SSUpdater())
        processor.updateDelegate = self;
    }
}

extension TaskView: SSUETaskUpdaterDelegate {
    func updater(_ updater: Any, didIncrementPages oldPages: Int) {
        print("\(title) increment pages for processor \(String(describing: processor.entity))")
    }
    
    func updater(_ updater: Any, didRenameTask oldTitle: String) {
        print("\(title) rename task for processor \(String(describing: processor.entity))")
    }
    
    func updaterDidRemoveTask(_ updater: Any) {
        print("\(title) remove task for processor \(String(describing: processor.entity))")
    }
}

public class ProcessorTester {
    var view1 = TaskView(title: "View 1")
    var view2 = TaskView(title: "View 2")
    
    public init() {}
    
    public func run() {
        start(handler: mutate)
    }
    
    private func mutate() {
        print("Satrt incrementing by view 1")
        view1.processor.mutator?.increment() {[weak self] (error) in
            print("Finish incrementing by view 1")
            
            print("Satrt renaming by view 2")
            self?.view2.processor.mutator?.rename(new: "Rename task") { (error) in
                print("Finish incrementing by view 2")
                print("Satrt renaming by view 2")
                self?.view2.processor.mutator?.remove() { (error) in
                    print("Finish removing by view 2")
                }
            }
        }
    }
    
    private func start(handler: @escaping ()->Void) {
        let group = DispatchGroup()
        
        group.enter()
        view1.processor.start {
            group.leave()
        }
        group.enter()
        view2.processor.start {
            group.leave()
        }
        group.notify(queue: DispatchQueue.main, execute: handler)
    }
}
