import Foundation
import SSSugarExecutors

/// DB stub
class DB {
    static var task : SSUETask? = SSUETask(taskID: 1, title: "Task 1", pages: 2)
    static var revision = 0
}

/// DB API stub
///
/// #Confroms to:
/// `SSUETaskApi`, `SSUETaskEditApi`
class SSUETaskDBApi {}

extension SSUETaskDBApi: SSUETaskApi {
    func getTask(taskID: Int) -> SSUETask? {
        return DB.task
    }
    
    func getTasks(bookID: Int) -> [SSUETask] {
        if let task = DB.task {
            return [task]
        }
        return []
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

/// Requirements for Task View
///
/// # Provides:
/// * `SSUETaskUpdaterDelegate` methods default implementation – prints update info.
protocol TaskViewing: SSUETaskUpdaterDelegate {
    associatedtype Processor: SSSingleEntityProcessing
    
    var title: String {get}
    var processor: Processor {get}
}

extension TaskViewing {
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

/// Task view
///
/// # Conforms to:
/// `TaskViewing`
class TaskDBView: TaskViewing {
    typealias Processor = SSUETaskProcessor
    var title: String
    var processor: Processor
    
    init(title mTitle: String, updater: SSUpdater) {
        title = mTitle
        processor = SSUETaskProcessor(taskID: 1, taskApi: SSUETaskDBApi(), mExecutor: DispatchQueue.bg, updateCenter: updater)
        processor.updateDelegate = self
    }
}

/// Task Batch requests applier stub.
class SSUETaskBatchApplier: SSDmBatchApplier {
    typealias Request = SSModify
    
    var failIndex = [Int]() //used for test purpouses
    var api = SSUETaskDBApi()
    
    func applyBatches(_ batches: [Batch], revNumber: Int, handler: @escaping Handler) {
        DispatchQueue.bg.async {[weak self] in
            self?.apply(batches, revNumber: revNumber, handler: handler)
        }
    }
    
    func apply(_ batches: [Batch], revNumber: Int, handler: @escaping Handler) {
        if (DB.revision != revNumber) {
            handler(.revisionMissmatch)
        } else {
            if (!failIndex.isEmpty) {
                handler(.invalidData(indexes:failIndex))
            } else {
                func apply(_ request: Request) {
                    let core = request.core as! SSUETaskDMCore
                    
                    switch request.title {
                    case SSUETaskIncrementPagesRequest.title:
                        try! api.incrementPages(taskID: core.taskID)
                    case SSUETaskRenameRequest.title:
                        let mCore = core as! SSUETaskRenameDmCore
                        
                        try! api.renameTask(taskID: mCore.taskID, title: mCore.taskTitle)
                    case SSUETaskRemoveRequest.title:
                        try! api.removeTask(taskID: core.taskID)
                    default:
                        fatalError("Unexpected request")
                    }
                }
                batches.forEach { $0.requests.forEach(apply(_:)) }
                handler(nil)
            }
        }
    }
}

class TaskDmView<Dispatcher: SSDmRequestDispatcher>: TaskViewing where Dispatcher.Request == SSModify {
    typealias Processor = SSUETaskDmProcessor<TaskDmView, Dispatcher>
    var title: String
    var processor: Processor

    init(title mTitle: String, updateCenter: SSUpdateCenter, dispatcher: Dispatcher) {
        title = mTitle
        
        processor = SSUETaskDmProcessor<TaskDmView, Dispatcher>(taskID: 1, taskApi: SSUETaskDBApi(), executor: DispatchQueue.bg, dispatcher: dispatcher, updateCenter: updateCenter)
        processor.updateDelegate = self
    }
}

public class ProcessorTester {
    typealias ModifyCenter = SSDataModifyCenter<SSModify, SSModify, SSUETaskBatchApplier, SSUEBatchAdpater>
    
    var updater = SSUpdater()
    var modifyCenter: ModifyCenter
    var view1: TaskDmView<ModifyCenter>
    var view2: TaskDmView<ModifyCenter>
    
    public init() {
        modifyCenter = ModifyCenter(revisionNumber: 0, updateNotifier: updater, batchApplier: SSUETaskBatchApplier(), adapter: SSUEBatchAdpater())
        view1 = TaskDmView(title: "View 1", updateCenter: updater, dispatcher: modifyCenter)
        view2 = TaskDmView(title: "View 2", updateCenter: updater, dispatcher: modifyCenter)
    }
    
    public func run() {
        start {[weak self] in self?.onStart() }
    }
    
    private func onStart() {
        mutate()
    }
    
    private func mutate() {
        func renameViaChange(_ handler: @escaping ()->Void) {
            func change() {
                DB.revision += 1
                
                let change = SSUETaskRenameChange(taskID: 1, taskTitle: "Ch title")
                let revision = SSUERevision(number: DB.revision, changes: [change])
                
                DB.task?.title = change.iCore.taskTitle
                DispatchQueue.main.async(execute: handler)
                if let error = modifyCenter.dispatchRevisions([revision]) {
                    print("Revision dispatch error \(error)")
                } else {
                    print("Revision dispatched")
                }
            }
            print("Start CH rename")
            DispatchQueue.bg.async(execute: change)
        }
        func increment(_ handler: @escaping ()->Void) {
            print("DB task: \(String(describing: DB.task))")
            print("Start incrementing by view 1")
            view1.processor.mutator?.increment() {(error) in
                print("Finish incrementing by view 1")
                print("DB task: \(String(describing: DB.task))")
                DispatchQueue.main.async(execute: handler)
            }
        }
        func removeViaChange(_ handler: @escaping ()->Void) {
            func change() {
                DB.revision += 1
                
                let change = SSUETaskRemoveChange(taskID: 1)
                let revision = SSUERevision(number: DB.revision, changes: [change])
                
                DB.task = nil
                DispatchQueue.main.async(execute: handler)
                if let error = modifyCenter.dispatchRevisions([revision]) {
                    print("Revision dispatch error \(error)")
                } else {
                    print("Revision dispatched")
                }
            }
            print("Start CH remove")
            DispatchQueue.bg.async(execute: change)
        }
        func rename(_ handler: @escaping ()->Void) {
            print("Start renaming by view 2")
            view2.processor.mutator?.rename(new: "Req task") {(error) in
                print("Finish renaming by view 2")
                print("DB task: \(String(describing: DB.task))")
                DispatchQueue.main.async(execute: handler)
            }
        }
        func remove(_ handler: @escaping ()->Void) {
            print("Start removing by view 2")
            view2.processor.mutator?.remove() { (error) in
                print("Finish removing by view 2")
                print("DB task: \(String(describing: DB.task))")
                DispatchQueue.main.async(execute: handler)
            }
        }
        SSChainExecutor()
            .add(renameViaChange)
            .add(increment)
            .add(removeViaChange).add(rename).add(remove)
            .finish()
    }
    
    private func start(handler: @escaping ()->Void) {
        SSGroupExecutor()
            .add(view1.processor.start)
            .add(view2.processor.start)
            .finish(handler)
    }
}
