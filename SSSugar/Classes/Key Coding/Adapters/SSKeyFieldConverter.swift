import Foundation

/// Tool that creates adapters for `KeyField` for common cases
public class SSKeyFieldConverter {
    /// Creates adapter for `KeyField<Date>` field to convert with Int
    /// - Returns: Created adapter
    public static func dateIntAdapter() -> SSKeyField<Date>.Adapter {
        func toDate(parsed: Any?) -> Date {
            guard let val = parsed as? Int else { fatalError() }
            return Date(timeIntervalSince1970: Double(val))
        }
        return SSKeyField<Date>.Adapter(to:toDate, from: { Int($0.timeIntervalSince1970) })
    }
    
    /// Creates adapter for `KeyField<UUID>` field to convert with String
    /// - Returns: Created adapter
    public static func uuidStringAdapter() -> SSKeyField<UUID>.Adapter {
        return SSKeyField<UUID>.Adapter(to:{ UUID(uuidString: $0 as! String)! }, from: { $0.uuidString })
    }
}
