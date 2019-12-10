//
//  SSEntityRemoteMutator.swift
//  SSSugar
//
//  Created by Stanislav Dmitriyev on 10/12/19.
//  Copyright © 2019 Stanislav Dmitriyev. All rights reserved.
//

import Foundation

/// Base class for any Entity Mutator that works with Remote Storage. Remote storage – any place with hight latency and asynchronious interface and splited communication. (Back-end server, cloud etc.). Splitted communications means that async modfication is only intent (not an real modification) and system should wait on notification that arrives via 'SSUpdateReceiversManaging' to ensure modification is applied. Mutator will match notification on modifiation by marker and will call it's handler.
/// - Note:
/// It's inheritors responsobility to provide storage modification logic (usually it's api calls). Also inheritor must implements it's notifications handling by simply calling `handleUpdate(marker:error:)` method. See examples for more info.
open class EntityRemoteMutator<Source: SSMutatingEntitySource>: SSBaseEntityMutating {
    /// Type for handler closure
    public typealias Handler = (Error?)->Void
    /// Protected type for job closure (modification behaviour). See `mutate(job:handler:)`. Should be used only within inheritors.
    public typealias AsyncJob = (String, Handler)->Void
    
    public unowned let source: Source
    
    /// Manager to subscibe on notifications for mathing them with modifications.
    public let manager: SSUpdateReceiversManaging
    
    /// Finish handlers stored by markers.
    private var handlers = [String : (Error?) -> Void]()
    
    /// Creates new Remote Mutator instance. Should be used only within inheritor.
    /// - Parameters:
    ///   - source: Entity source. See coresponding property.
    ///   - manager: Updates receiver manager. See coresponding property.
    public init(source mSource: Source, manager mManager: SSUpdateReceiversManaging) {
        manager = mManager
        source = mSource
        manager.addReceiver(self)
    }

    deinit {
        manager.removeReceiver(self)
    }
    
    /// Protected method for mutating entity.
    /// - Important: By design this method should be used only withing inheritors.
    /// - Parameters:
    ///   - job: Closure that modifyes storage. Usually its Api call.
    ///   - handler: Finish handler.
    public func mutate(job: @escaping AsyncJob, handler: @escaping Handler) {
        let marker = Self.newMarker()

        func onBg() {
            store(handler: handler, marker: marker)
            job(marker, remoteHandler(with: marker))
        }
        DispatchQueue.bg.async(execute: onBg)
    }
    
    /// Protected method for handling notifications. Should be used only whithing inheritors in every SSUpdatesReceiver's method.
    /// - Parameters:
    ///   - marker: Notification marker.
    ///   - error: Error.
    public func handleUpdate(with marker: String, error: Error? = nil ) {
        handlers.pick(for: marker)?(nil)
    }
    
    /// Store passed finish handler for matching in future.
    /// - Parameters:
    ///   - handler: Closure to store
    ///   - marker: Modification marker which identify notification for handler matching.
    private func store(handler: @escaping (Error?) -> Void, marker: String) {
        handlers[marker] = handler
    }
    
    /// Creates handler that will call stored handler for passed marker in case of error occurs.
    /// - Parameter marker: marker for handler matching.
    private func remoteHandler(with marker: String) -> Handler {
        return {[weak self](error) in
            if let mError = error {
                DispatchQueue.bg.async {[weak self] in
                    self?.handleUpdate(with: marker, error: mError)
                }
            }
        }
    }
}

extension EntityRemoteMutator: SSUpdateReceiver {
    public func reactions() -> SSUpdate.ReactionMap { return [:] }
}

