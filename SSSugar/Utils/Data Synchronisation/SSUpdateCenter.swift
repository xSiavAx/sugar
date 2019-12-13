import Foundation

#warning("Race condition")
//TODO: It's reace condition on add/remove observer. Add usually calls from BG queue. Remove may be called within `deinit` from main queue.

/// Updater protocol with requierement to managing receivers
public protocol SSUpdateReceiversManaging {
    /// Start sending notofications for passed listeners
    ///
    /// - Parameter receiver: Receiver to add
    func addReceiver(_ receiver: SSUpdateReceiver)
    
    /// Stop sending notofications for passed listeners
    ///
    /// - Parameter receiver: Receiver for remove
    func removeReceiver(_ receiver: SSUpdateReceiver)
}

/// Updater protocol with requierement to notifying
public protocol SSUpdateNotifier {
    /// Send passed notification for all listeners that wait for it (except passed ignores)
    ///
    /// - Parameters:
    ///   - info: Information for notification
    func notify(info: SSUpdate)
}

public protocol SSUpdateCenter: SSUpdateReceiversManaging, SSUpdateNotifier {}

/// Concreate Update Center implementation that use SDK's Notification Center inside.
public class SSUpdater: SSUpdateCenter {
    /// Internal class for simplyfy Update Center code.
    class Observer {
        var tokens : [AnyObject]?
        var receiver : SSUpdateReceiver
        var converter : UpdatesConverter
        
        init(receiver mReceiver: SSUpdateReceiver, converter mConverter: UpdatesConverter) {
            receiver = mReceiver
            converter = mConverter
        }
    }
    class UpdatesConverter {}
    private var observers = [Observer]()
    private var converter = UpdatesConverter()
    
    public init() {}
}

extension SSUpdater: SSUpdateReceiversManaging {
    //MARK: SSUpdateReceiversManaging
    public func addReceiver(_ receiver: SSUpdateReceiver) {
        let observer = Observer(receiver: receiver, converter: converter)
        
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
}

extension SSUpdater: SSUpdateNotifier {
    //MARK: SSUpdateNotifier
    public func notify(info: SSUpdate) {
        NotificationCenter.default.post(converter.notification(from: info))
    }
}

extension SSUpdater.UpdatesConverter {
    private static let markerKey = "notification_marker"
    private static let argsKey = "notification_args"
    
    public func info(from notification: Notification) -> SSUpdate {
        guard let userInfo = notification.userInfo else {
            fatalError("Invalid notification")
        }
        let marker = userInfo[Self.markerKey] as! String
        let args = userInfo[Self.argsKey] as! [AnyHashable : Any]
        
        return SSUpdate(name: notification.name.rawValue, marker: marker, args: args)
    }

    public func notification(from info: SSUpdate) -> Notification {
        let notName = Notification.Name(rawValue: info.name)
        let userInfo = [Self.markerKey : info.marker, Self.argsKey : info.args] as [AnyHashable : Any]
        return Notification(name: notName, object: nil, userInfo: userInfo)
    }
}

extension SSUpdater.Observer {
    /// Register receiver's reactions in Notification Center
    func startObserving() {
        tokens = receiver.reactions().map(register)
    }
    
    /// Unregister receiver's reactions from Notification Center
    func stopObserving() {
        guard let mTokens = tokens else { fatalError("Observer wasn't started") }
        for token in mTokens { NotificationCenter.default.removeObserver(token) }
        tokens = nil
    }
    
    //MARK: private
    private func register(name: String, reaction: @escaping SSUpdate.Reaction) -> AnyObject {
        func process(notification: Notification) {
            reaction(converter.info(from: notification))
        }
        let token = NotificationCenter.default.addObserver(forName: Notification.Name(name),
                                                           object: nil,
                                                           queue: nil,
                                                           using: process(notification:))
        return token
    }
}
