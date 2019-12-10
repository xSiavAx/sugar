import Foundation

#warning("Implements me")

//public protocol SSDataUpdate: SSUpdateInvalidating {
//    var marker: String {get set}
//
//    func createUpdate() -> SSUpdate
//    func apply(api: Any) throws //Make class for api?
//}
//
//public protocol SSUpdateInvalidating {
//    mutating func invalidate<Update: SSDataUpdate>(by update: Update) throws //can't resolve
//}
//
//public protocol SSUpdateConflicting {
//    //Может сделать розолв конфликта по принципу двойного инвалидейта???
//    //Тогда нужна будет проверка, а конфликтуют ли вообще (что бы не делать лишнюю копию)
//    mutating func resolve<Update: SSDataUpdate>(with update: Update) throws //invalid state
//}
//
//public protocol SSConcreateUpdateInvalidating {
//    func invalidate(by increment: SSTaskIncrementPagesUpdate)
//}
//
//public protocol SSConcreateUpdateConflicting {
//    func resolve(with increment: SSTaskIncrementPagesUpdate)
//}
//
//public struct SSDataVersion {
//    var major : Int
//    var minor : Int
//}
//
//extension SSDataVersion: Comparable {
//    public static func < (lhs: SSDataVersion, rhs: SSDataVersion) -> Bool {
//        if (lhs.major < rhs.major) {
//            return true;
//        }
//        if (lhs.major == rhs.major) {
//            return lhs.minor < rhs.minor;
//        }
//        return false;
//    }
//}
//
//public class SSBaseDataUpdate: EntityMutator {
//    public var marker: String
//    public var title: String { Self.title }
//    class var title: String { "none" }
//    static var invalidates : [String : ()->Void]?
//
//    init(marker mMarker: String) {
//        marker = mMarker
//    }
//
//    init() {
//        marker = Self.newMarker()
//    }
//}
//
//// Start. Имплементируем invalidate для SSBaseDataUpdate если в нем (или его наследнике) имплементирован 'SSConcreateUpdateInvalidating'
//public protocol SSDataUpdateInvalidating : SSBaseDataUpdate {}
//
//extension SSDataUpdateInvalidating where Self: SSConcreateUpdateInvalidating {
//    public func invalidate<Update: SSDataUpdate>(by update: Update) throws {
//        let baseUpdate = update as! SSBaseDataUpdate
//        Self.createInvalidatesIfNeeded()
//        Self.invalidates![baseUpdate.title]!()
//    }
//
//    private static func createInvalidatesIfNeeded() {
//        if (invalidates == nil) {
//            invalidates = createInvalidates()
//        }
//    }
//
//    private static func createInvalidates() -> [String : ()->Void] {
//        return [String : ()->Void]()
//    }
//}
//
//extension SSBaseDataUpdate: SSDataUpdateInvalidating {}
//// End.
//
//// Start.
//
//protocol SSDataUpdateConflicting: SSDataUpdate {}
//
//extension SSDataUpdateConflicting where Self: SSConcreateUpdateConflicting {
//
//    public func invalidate<Update: SSDataUpdate>(by update: Update) throws {
//        let baseUpdate = update as! SSBaseDataUpdate
//        Self.createInvalidatesIfNeeded()
//        Self.invalidates![baseUpdate.title]!()
//    }
//
//    private static func createInvalidatesIfNeeded() {
//        if (invalidates == nil) {
//            invalidates = createInvalidates()
//        }
//    }
//
//    private static func createInvalidates() -> [String : ()->Void] {
//        return [String : ()->Void]()
//    }
//}
//
//extension SSBaseDataUpdate: SSDataUpdateInvalidating {}
//// End.
//
//public class SSBaseTaskUpdate: SSBaseDataUpdate, TaskUpdate {}
//
//public class SSTaskIncrementPagesUpdate: SSBaseTaskUpdate {
//    public var taskID : Int
//    public var prevPages: Int
//
//    init(taskID mTaskID: Int, prevPages mPrevPages: Int) {
//        taskID = mTaskID
//        prevPages = mPrevPages
//        super.init()
//    }
//}
//
//extension SSTaskIncrementPagesUpdate: SSConcreateUpdateInvalidating {
//    public func invalidate(by increment: SSTaskIncrementPagesUpdate) {
//        prevPages += 1
//    }
//}
//
//extension SSTaskIncrementPagesUpdate: SSDataUpdate {
//    public func createUpdate() -> SSUpdate {
//        return incrementPages(taskID: taskID, marker: marker)
//    }
//
//    public func apply(api: Any) throws {
//        let dbApi = api as! TaskEditApi
//
//        try dbApi.incrementPages(taskID: taskID)
//    }
//}
//
////TODO: Resolve conflict
////TODO: create 'update' for letter sending
////TODO: create notification
//
//public protocol OfflineMutatorVersionSource: AnyObject {
//    var current: SSDataVersion {get}
//}
//
//public protocol UpdatesSource: AnyObject {
//    associatedtype Version: Comparable
//    associatedtype Update: SSDataUpdate
//    func diff(from: Version) -> [Update]?
//}
//
//public protocol TaskSource: AnyObject {
//    var task: Task? {get}
//}
//
//public class TaskOfflineMutator<Differ: UpdatesSource>: OnMainDispatcher where Differ.Version == SSDataVersion {
//    public unowned let uiVersions: OfflineMutatorVersionSource
//    public weak var source: TaskSource?
//    public weak var differ: Differ?
//    public let executor: Executor
//    public let notifier: SSUpdateNotifier
//    public let api: TaskEditApi
//
//    init(uiVersionSource: OfflineMutatorVersionSource, executor mExecutor: Executor, notifier mNotifier: SSUpdateNotifier, api mApi: TaskEditApi) {
//        uiVersions = uiVersionSource
//        executor = mExecutor
//        notifier = mNotifier
//        api = mApi
//    }
//}
//
////Как быть с ситуацией, когда мы решили конфликт, но на этапе отправки на сервер получили ошибку (например уперлись в лимит)?
//
////Вероятнее всего прийдется таки описать оффлайн синхронизатор.
//
//extension TaskOfflineMutator: TaskMutator {
//    public func increment(_ handler: @escaping (Error?) -> Void) {
//        if let task = source?.task {
//            let version = uiVersions.current
//            let update = SSTaskIncrementPagesUpdate(taskID: task.taskID, prevPages: task.pages)
//
//            func exec() throws {
//                if let diff = differ?.diff(from: version) {
//                    try diff.map() { try update.invalidate(by: $0) }
//                }
//                try update.apply(api: api)
//                //SAVE update
//                //Более того, тут стоит применить транзакцию!
//            }
//        }
//    }
//
//    public func rename(new name: String, _ handler: @escaping (Error?) -> Void) {
//        <#code#>
//    }
//
//    public func remove(_ handler: @escaping (Error?) -> Void) {
//        <#code#>
//    }
//}
