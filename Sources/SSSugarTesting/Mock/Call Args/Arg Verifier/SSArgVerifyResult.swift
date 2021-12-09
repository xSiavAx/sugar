import Foundation

public enum SSArgVerifyResult {
    case success
    case failure(String)
    
    public static func fromConsume<T>(result: SSArgVerifyConsumeResult<T>, onValue: (T) -> Self) -> Self {
        switch result {
        case .cantCast(let val):
            return .failure("Can't cast `\(String(describing: val))` to `\(T.self)`")
        case .empty:
            return forEmpty()
        case .success(let val):
            return onValue(val)
        }
    }
    
    public static func forEmpty() -> Self {
        return .failure("No enought call arguments to satisfy expecting")
    }
}
