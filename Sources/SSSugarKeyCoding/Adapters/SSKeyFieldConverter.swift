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
        return .init(to: { .init(ts: $0 as! Int) }, from: { $0.ts })
    }
}

extension SSKeyField.Adapter where T == Date? {
    /// Creates adapter for `KeyField<Date?>` field to convert with string.
    ///
    /// - Returns: Created adapter
    public static func strAdapter(format: String) -> SSKeyField<T>.Adapter {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        func toDate(parsed: Any?) -> Date? {
            guard parsed != nil else { return nil }
            
            return formatter.date(from: parsed as! String)
        }
        func fromDate(val: Date?) -> Any? {
            guard let mVal = val else { return nil }
            
            return formatter.string(from: mVal)
        }
        return .init(to:toDate, from: fromDate)
    }
    
    public static func intAdapter() -> SSKeyField<T>.Adapter {
        func toDate(parsed: Any?) -> Date? {
            guard parsed != nil else { return nil }
            
            return .init(ts: parsed as! Int)
        }
        func fromDate(_ date: Date?) -> Any? {
            guard let date = date else { return nil }

            return date.ts
        }
        return .init(to: toDate, from: fromDate)
    }
}

extension SSKeyField.Adapter where T == UUID {
    public static func strAdapter() -> SSKeyField<T>.Adapter {
        return .init(to:{ UUID(uuidString: $0 as! String)! }, from: { $0.uuidString })
    }
}

extension SSKeyField.Adapter where T == URL {
    public static func strAdapter() -> SSKeyField<T>.Adapter {
        return .init(to: { URL(string: $0 as! String)! }, from: { $0.absoluteURL })
    }
}

public extension SSKeyField.Adapter where T: RawRepresentable {
    static func rawAdapter() -> SSKeyField<T>.Adapter {
        return T.keyFieldAdapter()
    }
}

public extension SSKeyField.Adapter {
    static func rawAdapter<Wrapped>() -> SSKeyField<Wrapped?>.Adapter
    where T == Optional<Wrapped>, Wrapped: RawRepresentable {
        return T.keyFieldAdapter()
    }
}

//TODO: See how we could upgrade SSErrorConverter and SSApiErrorConverter using RawRepresentable.
// For that purpouses we could add `to`, `from`, `read` and `write` to RawRepresentable.
public extension RawRepresentable {
    static func keyFieldAdapter() -> SSKeyField<Self>.Adapter {
        func to(val: Any?) -> Self {
            return Self(rawValue: val as! RawValue)!
        }
        func from(val: Self) -> Any? {
            return val.rawValue
        }
        return .init(to: to, from: from)
    }
}

public extension Optional where Wrapped: RawRepresentable {
    static func keyFieldAdapter() -> SSKeyField<Self>.Adapter {
        func to(val: Any?) -> Self {
            guard let raw = val as? Wrapped.RawValue else { return nil }
            return Wrapped(rawValue: raw)
        }
        func from(val: Self) -> Any? {
            return val?.rawValue
        }
        return .init(to: to, from: from)
    }
}

