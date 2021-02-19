import Foundation

/// Structs for simplyfy passing data inside Updates system
public struct SSUpdate {
    ///Update arguments type
    public typealias Args = [AnyHashable : Any]
    ///Update reaction type
    public typealias Reaction = (Self)->Void
    ///Update reactions dict type
    public typealias ReactionMap = [String : Reaction]
    
    /// Update title
    public let name : String
    /// Update identifier
    /// Usually it used to match update on it's request
    public let marker : String
    /// Update arguments
    public let args : Args
    
    /// Create new Update
    /// - Parameters:
    ///   - name: Update's title
    ///   - marker: Update's marker
    ///   - args: Update's arguments
    public init(name mName: String, marker mMarker: String, args mArgs: Args? = nil) {
        name = mName
        marker = mMarker
        args = mArgs ?? Args()
    }
}
