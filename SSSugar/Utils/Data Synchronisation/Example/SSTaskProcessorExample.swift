import Foundation

class DB {
    static var task : SSUETask? = SSUETask(taskID: 1, title: "Task 1", pages: 2)
}

class SSUETaskDBApi {}

extension SSUETaskDBApi: SSUETaskApi {
    func getTask(taskID: Int) -> SSUETask? {
        return DB.task?.copy()
    }
    
    func getTasks(bookID: Int) -> [SSUETask] {
        if let task = DB.task {
            return [task.copy()]
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
        print("DB task: \(String(describing: DB.task))")
        print("Start incrementing by view 1")
        view1.processor.mutator?.increment() {[weak self] (error) in
            print("Finish incrementing by view 1")
            print("DB task: \(String(describing: DB.task))")
            print("Start renaming by view 2")
            self?.view2.processor.mutator?.rename(new: "Rename task") { (error) in
                print("Finish incrementing by view 2")
                print("DB task: \(String(describing: DB.task))")
                print("Start removing by view 2")
                self?.view2.processor.mutator?.remove() { (error) in
                    print("Finish removing by view 2")
                    print("DB task: \(String(describing: DB.task))")
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
