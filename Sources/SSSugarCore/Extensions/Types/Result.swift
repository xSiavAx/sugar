import Foundation

/// Banch of methods that helps reduce code amount and avoid code duplication in `Result` processing
public extension Result {
    
    /// Unwraps result, calls `onFail` on `.failure` case and `onSuccess` on `.success` case
    /// - Parameters:
    ///   - onFail: Closure to be called on `.failure` case
    ///   - onSuccess: Closure to be called on `.success` case
    func unwrap(onFail: (Failure) -> Void, onSuccess: (Success) -> Void) {
        switch self {
        case let .failure(error):
            onFail(error)
        case let .success(success):
            onSuccess(success)
        }
    }
    
    /// Unwraps result, calls `completion` on `.failure` case and `onSuccess` on `.success` case
    /// - Parameters:
    ///   - completion: Closure to be called on `.failure` case
    ///   - onSuccess: Closure to be called on `.success` case
    func unwrap<AnyResult>(completion: (Result<AnyResult, Failure>) -> Void, onSuccess: (Success) -> Void) {
        unwrap(onFail: { completion(.failure($0)) }, onSuccess: onSuccess)
    }
    
    /// Unwraps result, put error to passed eror and calls `onFail` on `.failure` case; calls `onSuccess` on `.success` case
    /// - Parameters:
    ///   - error: Error to copy internal error to on `.failure` case
    ///   - onFail: Closure to be called on `.failure` case
    ///   - onSuccess: Closure to be called on `.success` case
    func unwrap(to error: inout Error?, onFail: () -> Void, onSuccess: () -> Void) {
        switch self {
        case .success:
            onSuccess()
        case .failure(let cause):
            error = cause
            onFail()
        }
    }
    
    func onSuccess(_ job: (Success) -> Void) {
        unwrap(onFail: { _ in }, onSuccess: job)
    }
}

public extension Result where Failure == Error {
    func tryMap<T>(_ map: (Success) throws -> T) -> Result<T, Error> {
        return flatMap {
            do {
                return .success(try map($0))
            } catch {
                return .failure(error)
            }
        }
    }
}

public extension Result where Success == Void {
    /// Builds Result with passed error
    /// - Parameter error: Error to initialise Result with
    /// - Returns: `.failure` with passed `error` if it's not nil and `.success` otherwise
    static func from(error: Failure?) -> Self {
        if let error = error {
            return .failure(error)
        }
        return .success(())
    }
}
