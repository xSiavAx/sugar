import Foundation

/// Requirements for any mutator that works with Task entity
internal protocol SSUETaskMutator {
    func increment(_ handler: @escaping (Error?)->Void)
    func rename(new name: String, _ handler: @escaping (Error?)->Void)
    func remove(_ handler: @escaping (Error?)->Void)
}
