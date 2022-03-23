import Foundation

/// Recomended to use on closures or weak stored properties, to avoid retain cycles.
///
/// Using regular `ValueCaptor` doesn't provide value overriding protection and may cause unexpected behaviour – value that captured will not be released until it overrides by another one or captor itslef releases. And that may cause memory leak or even unexpected behaviour. For example `deinit` will not be called for captured value (or values captured by it and so on).
///
/// - Warning: Using same ReleasbleValueCaptor object for capturing defferent calls may cause `Already captured` fatal error, due to possible race condition – when capture 2nd value called before 1st captured value has released. So using different capture objects is much more safe way then use only one.
open class SSValueShortCaptor<Value>: SSBaseValueCaptor<Value> {
    open var released: Value {
        let val = protValue()
        
        resetValue()
        
        return val
    }
    
    open override func capture(value: Value) {
        if (hasValue) { fatalError("Already captured") }
        super.capture(value: value)
    }
    
    deinit {
        if (hasValue) {
            //Use `released` to release and apply captured value
            fatalError("\(self) hasn't released.")
        }
    }
}

extension SSValueShortCaptor {
    public static func forClosure<Ret>() -> SSValueShortCaptor<() -> Ret> {
        return .init(dummy: SSClosureStubFactory.it())
    }
    
    public static func forClosure<Ret, Arg1>() -> SSValueShortCaptor<(Arg1) -> Ret> {
        return .init(dummy: SSClosureStubFactory.it())
    }
    
    public static func forClosure<Ret, Arg1, Arg2>() -> SSValueShortCaptor<(Arg1, Arg2) -> Ret> {
        return .init(dummy: SSClosureStubFactory.it())
    }
    
    public static func forClosure<Ret, Arg1, Arg2, Arg3>() -> SSValueShortCaptor<(Arg1, Arg2, Arg3) -> Ret> {
        return .init(dummy: SSClosureStubFactory.it())
    }
    
    public static func forClosure<Ret, Arg1, Arg2, Arg3, Arg4>() -> SSValueShortCaptor<(Arg1, Arg2, Arg3, Arg4) -> Ret> {
        return .init(dummy: SSClosureStubFactory.it())
    }
    
    public static func forClosure<Ret, Arg1, Arg2, Arg3, Arg4, Arg5>() -> SSValueShortCaptor<(Arg1, Arg2, Arg3, Arg4, Arg5) -> Ret> {
        return .init(dummy: SSClosureStubFactory.it())
    }
}

extension SSValueShortCaptor {
    public static func forClosure<Ret>() -> SSValueShortCaptor<(() -> Ret)?> {
        return .init(dummy: SSClosureStubFactory.it())
    }

    public static func forClosure<Ret, Arg1>() -> SSValueShortCaptor<((Arg1) -> Ret)?> {
        return .init(dummy: SSClosureStubFactory.it())
    }

    public static func forClosure<Ret, Arg1, Arg2>() -> SSValueShortCaptor<((Arg1, Arg2) -> Ret)?> {
        return .init(dummy: SSClosureStubFactory.it())
    }

    public static func forClosure<Ret, Arg1, Arg2, Arg3>() -> SSValueShortCaptor<((Arg1, Arg2, Arg3) -> Ret)?> {
        return .init(dummy: SSClosureStubFactory.it())
    }

    public static func forClosure<Ret, Arg1, Arg2, Arg3, Arg4>() -> SSValueShortCaptor<((Arg1, Arg2, Arg3, Arg4) -> Ret)?> {
        return .init(dummy: SSClosureStubFactory.it())
    }

    public static func forClosure<Ret, Arg1, Arg2, Arg3, Arg4, Arg5>() -> SSValueShortCaptor<((Arg1, Arg2, Arg3, Arg4, Arg5) -> Ret)?> {
        return .init(dummy: SSClosureStubFactory.it())
    }
}

