import Foundation

/// Requierements for updates receiver. Each updates receiver should can build reactions for notifications he interested in.
public protocol SSUpdateReceiver: AnyObject {
    /// Strategies dict. Keys – notifications names, Values - closures that have to call other receiver's methods.
    ///
    /// - Returns: Strategies dict
    func reactions() -> SSUpdate.ReactionMap
}

/// Structs for simplyfy passing data inside Updates system
public struct SSUpdate {
    static let kIgnoreReceiversKey = "ignore_receivers"
    
    public typealias ReactionData = [AnyHashable : Any]
    public typealias Reaction = (ReactionData)->Void
    public typealias ReactionMap = [String : Reaction]
    
    /// Struct that storing pair – notification name and arguments dict.
    public struct Info {
        private(set) var name : String
        private(set) var data : ReactionData
        
        public init(name mName: String, data mData: ReactionData = ReactionData()) {
            name = mName
            data = mData
        }
        
        public init(notification: Notification) {
            self.init(name:notification.name.rawValue, data:notification.userInfo!)
        }
        
        /// Add receiver to ignore list for notification
        ///
        /// - Parameter receivers: receivers that should be ignored
        public mutating func addIgnore(_ receivers: [SSUpdateReceiver]) {
            data[kIgnoreReceiversKey] = receivers
        }
        
        
        /// Determine should specified receiver be ignored or not
        ///
        /// - Parameter receiver: Receiver to check
        /// - Returns: Check result
        public func shouldIgnore(receiver: SSUpdateReceiver) -> Bool {
            guard let ignores = data[kIgnoreReceiversKey] as? [SSUpdateReceiver] else {
                return false
            }
            return ignores.contains() {$0 === receiver}
        }
    }
}
