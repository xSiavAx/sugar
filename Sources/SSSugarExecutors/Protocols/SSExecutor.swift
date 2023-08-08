import Foundation

/// Requirements for tool that executes passed jobs.
///
/// Usually used to encapsulate some implementation (DispatchQueue for ex), it simplifies unit-tests.
public protocol SSExecutor {
    func execute(_ work: @escaping ()->Void)
}

extension SSExecutor {
    public func execute<T>(job: @escaping () throws -> T) async throws -> T {
        try await withCheckedThrowingContinuation { handler in
            execute {
                handler.resume(with: .init(catching: job))
            }
        }
    }

    public func execute<T>(job: @escaping () -> T) async -> T {
        await withCheckedContinuation { handler in
            execute {
                handler.resume(returning: job())
            }
        }
    }
}

/// Requirements for tool that executes passed jobs after some timeout.
///
/// Usually used to encapsulate some implementation (DispatchQueue for ex), it simplifies unit-tests.
public protocol SSTimeoutExecutor: SSExecutor {
    /// Executes passed job after some time interval
    /// - Parameters:
    ///   - sec: Time interval length in secconds
    ///   - work: Joib to be executed
    func executeAfter(sec: Double, _ work: @escaping () -> Void)
    
    /// Executes passed job after some time interval
    /// - Parameters:
    ///   - sec: Time interval length in secconds
    ///   - work: Joib to be executed
    func executeAfter(sec: Int, _ work: @escaping () -> Void)
}

extension SSTimeoutExecutor {
    public func executeAfter<T>(sec: Double, job: @escaping () throws -> T) async throws -> T {
        try await withCheckedThrowingContinuation { handler in
            executeAfter(sec: sec) {
                handler.resume(with: .init(catching: job))
            }
        }
    }

    public func execute<T>(sec: Double, job: @escaping () -> T) async -> T {
        await withCheckedContinuation { handler in
            executeAfter(sec: sec) {
                handler.resume(returning: job())
            }
        }
    }

    public func executeAfter<T>(sec: Int, job: @escaping () throws -> T) async throws -> T {
        try await withCheckedThrowingContinuation { handler in
            executeAfter(sec: sec) {
                handler.resume(with: .init(catching: job))
            }
        }
    }

    public func execute<T>(sec: Int, job: @escaping () -> T) async -> T {
        await withCheckedContinuation { handler in
            executeAfter(sec: sec) {
                handler.resume(returning: job())
            }
        }
    }
}

/// Requirements for SSTimeoutExecutor that owns underlied gcd queue
public protocol SSGCDExecutor: SSTimeoutExecutor {
    /// Returns underlied GCD queue
    func underliedQueue() -> DispatchQueue
}

/// Requeirements to executor that able to execute job on main queue.
/// - Note:
/// Default implementation provided (via GCD main queue). Any class implementing this protocol may not implement it's methods and use their default implementation.
public protocol SSOnMainExecutor {
    /// Asynchroniously execute passed closure on Main queue.
    /// - Parameter work: Closure to execute
    func onMain(_ work: @escaping ()->Void)
}

extension SSOnMainExecutor {
    public func onMain(_ handler: @escaping ()->Void) {
        DispatchQueue.main.async(execute: handler)
    }
}
