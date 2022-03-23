import Foundation

/// Recomended to use with `Value Type` values or with `Reference Type` values which may usually leaves much more longer then call that mocked (usually it's not an closures or values of weak stored properties). For other cases apply ValueShortCaptor.
open class SSValueCaptor<Value>: SSBaseValueCaptor<Value> {
    open var value: Value { protValue() }
}
