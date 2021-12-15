import Foundation

public enum SSArgVerifyConsumeResult<T> {
    case success(T)
    case empty
    case cantCast(val: Any?)
}
