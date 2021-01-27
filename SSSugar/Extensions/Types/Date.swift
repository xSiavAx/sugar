import Foundation

public extension Date {
    init(ts: Int) {
        self.init(timeIntervalSince1970: TimeInterval(ts))
    }
    
    /// Timestamp - The integer interval between the date value and 00:00:00 UTC on 1 January 1970.
    var ts: Int { Int(timeIntervalSince1970) }
    
    /// Creates new date with current time stamp – integer interval between now and 00:00:00 UTC on 1 January 1970.
    static func tsBased() -> Date {
        return Date(timeIntervalSince1970: Double(Int(Date().timeIntervalSince1970)))
    }
}
