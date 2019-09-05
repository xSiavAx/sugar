import Foundation

/// Updater protocol with requierement to Updater implementation.
public protocol SSUpdateCenter {
    /// Start sending notofications for passed listeners
    ///
    /// - Parameter receiver: Receiver to add
    func addReceiver(_ receiver: SSUpdateReceiver)
    
    /// Stop sending notofications for passed listeners
    ///
    /// - Parameter receiver: Receiver for remove
    func removeReceiver(_ receiver: SSUpdateReceiver)
    
    
    /// Send passed notification for all listeners that wait for it (except passed ignores)
    ///
    /// - Parameters:
    ///   - info: Information for notification
    ///   - receivers: list of receivers that sholdn't receive passed notification
    func notify(info: SSUpdate.Info, ignore receivers: SSUpdateReceiver...)
}

/// Concreate Update Center implementation that use SDK's Notification Center inside.
public class SSUpdater {
    /// Internal class for simplyfy Update Center code.
    class Observer {
        var tokens : [AnyObject]?
        var receiver: SSUpdateReceiver
        
        init(receiver mReceiver: SSUpdateReceiver) {
            receiver = mReceiver
        }
    }
    private var observers = [Observer]()
}

extension SSUpdater: SSUpdateCenter {
    //MARK: UpdateCenter
    public func addReceiver(_ receiver: SSUpdateReceiver) {
        let observer = Observer(receiver: receiver)
        
        observer.startObserving()
        observers.append(observer)
    }
    
    public func removeReceiver(_ receiver: SSUpdateReceiver) {
        observers.removeAll() {
            if ($0.receiver === receiver) {
                $0.stopObserving()
                return true
            }
            return false
        }
    }
    
    public func notify(info mInfo: SSUpdate.Info, ignore receivers: SSUpdateReceiver...) {
        if receivers.isEmpty {
            pNotify(info: mInfo)
        } else {
            pNotify(info: info(mInfo, ignoring: receivers))
        }
    }
    
    //MARK: private
    private func pNotify(info: SSUpdate.Info) {
        NotificationCenter.default.post(name: Notification.Name(info.name), object:nil, userInfo:info.data)
    }
    
    private func info(_ info: SSUpdate.Info, ignoring receivers: [SSUpdateReceiver]) -> SSUpdate.Info {
        var mInfo = info
        
        mInfo.addIgnore(receivers)
        return mInfo
    }
}

extension SSUpdater.Observer {
    /// Register receiver's reactions in Notification Center
    func startObserving() {
        tokens = receiver.reactions().map(register)
    }
    
    /// Unregister receiver's reactions from Notification Center
    func stopObserving() {
        guard let mTokens = tokens else { fatalError("Observer wan't started") }
        for token in mTokens { NotificationCenter.default.removeObserver(token) }
        tokens = nil
    }
    
    //MARK: private
    private func register(name: String, reaction: @escaping SSUpdate.Reaction) -> AnyObject {
        let token = NotificationCenter.default.addObserver(forName: Notification.Name(name),
                                                           object: nil,
                                                           queue: nil) { [weak self] (notification) in
                                                            self?.process(notification: notification, reaction: reaction)
        }
        return token
    }
    
    private func process(notification: Notification, reaction: SSUpdate.Reaction) {
        let info = SSUpdate.Info(notification: notification)
        
        if (!info.shouldIgnore(receiver: receiver)) {
            reaction(info.data)
        }
    }
}
