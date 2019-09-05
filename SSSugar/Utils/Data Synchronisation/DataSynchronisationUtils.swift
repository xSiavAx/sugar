import Foundation

/// Protocol with requirements for object that creates on obtain call. It helps user control obtain process.
public protocol SSObtainJob {
    var run: ()->Void {get}
    var didObtain: ()->Bool {get}
}

/// Protocol with requirements for object that creates on processor's edit call. It helps user control edit process.
public protocol SSEditJob {
    var onBg: ()->Error? {get}
    var onQueued: ()->Void {get}
}

/// Protocol with requirements for any object that can obtain model and create ObtainJob.
public protocol SSObtainJobCreator {
    func obtain() -> SSObtainJob
}

/// Class that help controlling obtain process. It can combine multiple Obtainers and repeat obtaining in case some of obtain result need be reobtain. Usually user use this controller inside presenter.
public class SSObtainJobController {
    /// Obtainers list
    public let creators : [SSObtainJobCreator]
    /// Queue to process obtain in
    public let bgQueue: DispatchQueue
    /// Finish handler
    public let onFinish : (()->Void)?
    
    /// Creates new Obtain Controller
    ///
    /// - Parameters:
    ///   - creators: obtainers list
    ///   - mBgQueue: queue to process obtain in
    ///   - mOnFinish: finish handler
    init(creators mCreators: [SSObtainJobCreator], bgQueue mBgQueue: DispatchQueue = DispatchQueue.bg, onFinish mOnFinish: (()->Void)? = nil ) {
        creators = mCreators
        onFinish = mOnFinish
        bgQueue = mBgQueue
        obtain()
    }
    
    private func obtain() {
        let jobs = creators.map() { $0.obtain() }
        
        func didObtain() {
            let success = jobs.reduce(true) {$0 && $1.didObtain()}
            success ? onFinish?() : obtain()
        }
        
        bgQueue.async {
            jobs.forEach() { $0.run() }
            DispatchQueue.main.async(execute:didObtain)
        }
    }
}

/// Class that help executing processor's edit methods. It can combine multiple actions.
public class SSEditJobExecutor {
    /// Edit that should be executed
    public typealias Editing = ()->SSEditJob
    
    /// Queue to process background edit job part in
    var bgQueue: DispatchQueue
    
    /// Create new executor
    ///
    /// - Parameter bgQueue: Queue to process background edit job part in
    init(bgQueue mBgQueue: DispatchQueue = DispatchQueue.bg) {
        bgQueue = mBgQueue
    }
    
    
    /// Exec passed list of edit jobs
    ///
    /// - Parameters:
    ///   - jobs: job list that should be executed
    ///   - onFinish: finish handler
    public func exec(jobs: [SSEditJob], onFinish: @escaping (Error?)->Void) {
        func processBG() {
            onFinish(process(bgs: jobs.map() {$0.onBg}))
        }
        bgQueue.async(execute: processBG)
        jobs.forEach() {$0.onQueued()}
    }
    
    /// Exec passed edit jobs
    ///
    /// - Parameters:
    ///   - job: job that should be executed
    ///   - onFinish: finish handler
    public func exec(job: SSEditJob, onFinish: @escaping (Error?)->Void) {
        exec(jobs: [job], onFinish: onFinish)
    }
    
    /// Exec passed list of editings
    ///
    /// - Parameters:
    ///   - editings: editings list that should be executed
    ///   - onFinish: finish handler
    public func exec(editings: [Editing], onFinish: @escaping (Error?)->Void) {
        exec(jobs: editings.map() {$0()}, onFinish: onFinish)
    }
    
    /// Exec passed editing
    ///
    /// - Parameters:
    ///   - editings: editing that should be executed
    ///   - onFinish: finish handler
    public func exec(editing: @escaping Editing, onFinish: @escaping (Error?)->Void) {
        exec(editings: [editing], onFinish: onFinish)
    }
    
    //MARK: - private
    private func process(bgs: [()->Error?]) -> Error? {
        for bg in bgs {
            if let error = bg() {
                return error
            }
        }
        return nil
    }
}
