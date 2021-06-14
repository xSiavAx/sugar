import Foundation

/// Requirements for communication task.
///
/// Communication task - task created for network request. It should reports it's status and may be canceled at any time.
public protocol SSCommunicatingTask {
    /// Indicates task is finished (or canceled) or in progress
    var finished: Bool {get}
    
    /// Cancel task.
    mutating func cancel()
}

/// Additional data that may be provided with response
///
/// - Note: Since `URLSession` doesn't allow get headers dict, we will use this addon protocol to provide headers data (and probably some other data in future) to user.
///
public protocol SSResponseAdditionData {
    func headerValue(for key: String) -> String?
}

/// Requirements for tool for communication
///
/// - Note: Network Communicator conforms to this protocol and should be used as `Communicating` by default. Protocol helps test tools that do communication.
public protocol SSCommunicating {
    /// Communication request callback type.
    ///
    /// - Parameters:
    ///   - body: Response body (if exist)
    ///   - headers: Response headers (if exist)
    ///   - error: Error occured during request preforming (if exist)
    typealias Handler = (_ body: Data?, _ addon: SSResponseAdditionData?, _ error: SSCommunicatorError?)->Void
    
    /// Creates and run communicating task (`CommunicatingTask`) – creates newtwork request, performs it, handle response and pass it arguments to callback.
    /// - Parameters:
    ///   - url: URL to prefrom request to.
    ///   - headers: Headers to add to request. Default is `nil`.
    ///   - body: Data to add to request as it's body.  Default is `nil`.
    ///   - handler: Callback. See `Handler` for more info.
    /// - Returns: Created communicating task.
    @discardableResult
    func runTask(url: URL, headers:[String:String]?, body: Data?, handler: @escaping Handler) -> SSCommunicatingTask
}

extension SSCommunicating {
    /// Creates and run communicating task (`CommunicatingTask`) – creates newtwork request, performs it, handle response and pass it arguments to callback.
    /// - Parameters:
    ///   - url: URL to prefrom request to.
    ///   - headers: Headers to add to request. Default is `nil`.
    ///   - body: Data to add to request as it's body.  Default is `nil`.
    ///   - handler: Callback. See `Handler` for more info.
    /// - Returns: Created communicating task.
    @discardableResult
    func runTask(url: URL, body: Data? = nil, handler: @escaping Handler) -> SSCommunicatingTask {
        runTask(url: url, headers: nil, body: body, handler: handler)
    }
}
