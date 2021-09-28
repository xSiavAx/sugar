import Foundation

/// Tool that creates adapters for `KeyField` for common cases
public class SSKeyFieldConverter {
    /// Creates adapter for `KeyField<Date>` field to convert with Int
    /// - Returns: Created adapter
    /// - Warning: **Deprecated**. Use `SSKeyField<Date>.Adapter.intAdapter()`.
    @available(*, deprecated, message: "Use `SSKeyField<Date>.Adapter.intAdapter()` instead")
    public static func dateIntAdapter() -> SSKeyField<Date>.Adapter {
        return .intAdapter()
    }
    
    /// Creates adapter for `KeyField<UUID>` field to convert with String
    /// - Returns: Created adapter
    /// - Warning: **Deprecated**. Use `SSKeyField<UUID>.Adapter.strAdapter()`.
    @available(*, deprecated, message: "Use `SSKeyField<UUID>.Adapter.strAdapter()` instead")
    public static func uuidStringAdapter() -> SSKeyField<UUID>.Adapter {
        return SSKeyField<UUID>.Adapter(to:{ UUID(uuidString: $0 as! String)! }, from: { $0.uuidString })
    }
}

extension SSKeyField.Adapter where T == Date {
    public static func intAdapter() -> SSKeyField<T>.Adapter {
        return .init(to: { Date(timeIntervalSince1970: Double($0 as! Int)) }, from: { Int($0.timeIntervalSince1970) })
    }
}

extension SSKeyField.Adapter where T == Date? {
    /// Creates adapter for `KeyField<Date?>` field to convert with string.
    ///
    /// - Returns: Created adapter
    public static func strAdapter(format: String) -> SSKeyField<Date?>.Adapter {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        func toDate(parsed: Any?) -> Date? {
            guard parsed != nil else { return nil }
            guard let val = parsed as? String else { fatalError() }
            
            return formatter.date(from: val)
        }
        func fromDate(val: Date?) -> Any? {
            guard let mVal = val else { return nil }
            
            return formatter.string(from: mVal)
        }
        return .init(to:toDate, from: fromDate)
    }
}

extension SSKeyField.Adapter where T == UUID {
    public static func strAdapter() -> SSKeyField<T>.Adapter {
        return .init(to:{ UUID(uuidString: $0 as! String)! }, from: { $0.uuidString })
    }
}

extension SSKeyField.Adapter where T == URL {
    public static func strAdapter() -> SSKeyField<T>.Adapter {
        return SSKeyField<T>.Adapter(to: { URL(string: $0 as! String)! }, from: { $0.absoluteURL })
    }
}
