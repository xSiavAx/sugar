import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Tool provides communication with network over HTTP requests.
///
/// Creates and wraps `URLSession` to perform network requests.
///
/// Creates `SSCertificatePinner` and pass it to session initializer to provide certificates pinning logic.
///
/// Creates application default session (`ephemeral`, no data has cached) or background (has extended prefroming time, may awake app on request callback...) session. See `init` for more info.
///
/// # Conforms to:
/// `Communicating`
public class SSNetworkCommunicator {
    public typealias URLSessionConfigSetup = (URLSessionConfiguration)->Void
    
    //TODO: Move log logic to separated tool
    
    /// Logging options Type. Only for debug purposes.
    ///
    /// Defines which properties of Request or Response should be logged.
    public struct LoggingOptions: OptionSet {
        public let rawValue: Int
        
        public init(rawValue value: Int) {
            rawValue = value
        }
        
        /// Indicates that `url` should be logged.
        public static let url = LoggingOptions(rawValue: 1 << 0)
        /// Indicates that `status` should be logged (for Responses only)
        public static let status = LoggingOptions(rawValue: 1 << 1)
        /// Indicates that `headers` should be logged.
        public static let headers = LoggingOptions(rawValue: 1 << 2)
        /// Indicates that `body` should be logged.
        public static let body = LoggingOptions(rawValue: 1 << 3)
        /// Indicates that all properties (`url`, `status`, `headers`, `body`) should be logged.
        public static let all: LoggingOptions = [.url, .status, .headers, .body]
    }
    
    /// Communication task, wraps `URLSessionTask`
    ///
    /// Used to return as `CommunicatingTask` in `NetworkCommunicator`.
    ///
    /// # Conforms to:
    /// `CommunicatingTask`
    private class Task: SSCommunicatingTask {
        /// Wraped SDK task
        let wrapedTask: URLSessionTask
        
        /// Indicates task is finished (or canceled) or in progress
        ///
        /// Value bases on wrapped task's state.
        var finished: Bool {wrapedTask.state == .canceling || wrapedTask.state == .completed}
        
        /// Creates new task with passed wraped SDK task
        /// - Parameter wrapping: SDK task to base on
        init(wrapping: URLSessionTask) {
            wrapedTask = wrapping
        }
        
        /// Cancel task. Call proxies to wrapped task.
        func cancel() {
            wrapedTask.cancel()
        }
    }
    #if !os(Linux)
    /// Certificate pinner used for `URLSession`
    public let pinner: SSCertificatePinner?
    #endif
    
    /// Wrapped session
    public let session: URLSession
    
    /// Logging options. Only for debug purposes.
    ///
    /// Set this var to see debug logs of requests or responses.
    private var logOptions: (requests: LoggingOptions?, response: LoggingOptions?) = (nil, nil)
    
    private var onLog: ((String)->Void)?
    
    /// Creates new Network Communicator.
    ///
    /// Creates application default session (`ephemeral`, no data has cached) if no background session identifier specified on init. Creates background (has extended prefroming time, may awake app on request callback...) session if some identifier specified on init. Usually you should use regular communicator, created with no session identifier.
    ///
    /// - Parameters:
    ///   - backgroundSessionIdentifier: Identifier for background session. Pass `nil` to create communicator for foreground tasks. Default is `nil`.
    ///   - certificatePinner: Certificate pinner if one is needed. See `SSCertificatePinner` for more details. To create pinner based on names of certificates that stores in assets use `init(backgroundSessionIdentifier: certificatePinner: onConfigSetup:)`
    ///   - onConfigSetup: Additional session configuration (`URLSessionConfiguration`) setup. Any Framework user could make extension with it's own `onConfigSetup` closure (including `nil`). `onConfigSetup` has no default value to avoid ambiguity of default constructor with one that user will define.
    #if !os(Linux)
    public init(backgroundSessionIdentifier: String? = nil, certificatePinner: SSCertificatePinner? = nil, onConfigSetup: URLSessionConfigSetup?) {
        func createConfig() -> URLSessionConfiguration {
            if let identifier = backgroundSessionIdentifier {
                return .appBackground(withIdentifier: identifier)
            }
            return .appDefault()
        }
        let config = createConfig()
        
        onConfigSetup?(config)
        
        pinner = certificatePinner
        
        if let mPinner = certificatePinner {
            session = URLSession(configuration: config, pinner: mPinner)
        } else {
            session = URLSession(configuration: config)
        }
    }
    
    public convenience init(backgroundSessionIdentifier: String? = nil, certificateTitles: [String], onConfigSetup: URLSessionConfigSetup?) {
        let pinner = SSCertificatePinner(obtainer: SSAssetCertificateObtainer(certTitles: certificateTitles))
        
        self.init(backgroundSessionIdentifier: backgroundSessionIdentifier, certificatePinner: pinner, onConfigSetup: onConfigSetup)
    }
    #else
    
    public init(onConfigSetup: URLSessionConfigSetup?) {
        let config = URLSessionConfiguration.appDefault()
        
        onConfigSetup?(config)
        
        session = URLSession(configuration: config)
    }
    
    #endif
    
    public func setupLogs(request: LoggingOptions, response: LoggingOptions, onLog mOnLog: ((String)->Void)?) {
        logOptions = (request, response)
        onLog = mOnLog
    }
}

extension SSNetworkCommunicator: SSCommunicating {
    public func runTask(url: URL, headers:[String:String]?, body: Data?, handler: @escaping Handler) -> SSCommunicatingTask {
        func onFinish(data: Data?, response: URLResponse?, error: Error?) {
            let httpResponse = response as? HTTPURLResponse
            
            logResponseIfNeeded(body: data, response: httpResponse, error: error)
            handler(data, httpResponse?.allHeaderFields, errorWith(libError: error, response: httpResponse))
        }
        let request = newRequest(withURL: url, headers: headers, body: body)
        let task = session.dataTask(with: request, completionHandler: onFinish)
        
        logRequestIfNeeded(url: url, headers: headers, body: body)
        
        task.resume()
        
        return Task(wrapping: task)
    }
    
    //MARK: private
    
    private func errorWith(libError: Error?, response: HTTPURLResponse?) -> SSCommunicatorError? {
        if let error = libError {
            return Self.errorFrom(libError: error)
        }
        if let code = response?.statusCode, code != 200 {
            return .unexpectedStatus(status: code)
        }
        return nil
    }
    
    private static func errorFrom(libError mError: Error) -> SSCommunicatorError {
        if let nsError = mError as NSError?, nsError.domain == NSURLErrorDomain, let error = errorFrom(urlDomainError: nsError) {
            return error
        }
        return .libError(libError: mError)
    }
    
    private static func errorFrom(urlDomainError error: NSError) -> SSCommunicatorError? {
        switch error.code {
        case NSURLErrorNotConnectedToInternet:
            return .noConnection
        case NSURLErrorCancelled:
            return .badCertificates
        default:
            return nil
        }
    }
    
    /// Creates new HTTP request to process with passed url, header params and body.
    ///
    /// - Parameters:
    ///   - withURL: Request's url
    ///   - headers: Request's header parameters.
    ///   - body: Request body
    private func newRequest(withURL: URL, headers:[String:String]?, body: Data?) -> URLRequest {
        var request = URLRequest(url: withURL)
        
        request.httpMethod = "POST"
        request.httpBody = body
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        return request
    }
    
    private func logRequestIfNeeded(url: URL, headers:[String:String]?, body: Data?) {
        if let options = logOptions.requests {
            log(title: "--- Request -->", url: url, headers: headers, body: body, options: options)
        }
    }
    
    private func logResponseIfNeeded(body: Data?, response: HTTPURLResponse?, error: Error?) {
        if let options = logOptions.response {
            log(title: "<-- Response ---",
                url: response?.url,
                headers: response?.allHeaderFields,
                body: body,
                status: response?.statusCode,
                options: options)
        }
    }

    private func log(title: String, url: URL?, headers:[AnyHashable:Any]?, body: Data?, status: Int? = nil, options: LoggingOptions) {
        var components = [String]()
        
        components.append(title)
        if (options.contains(.url)) {
            if let mUrl = url {
                components.append("\(mUrl)")
            } else {
                components.append("No URL")
            }
        }
        if let mStatus = status, options.contains(.status) {
            components.append("Status: \(mStatus)")
        }
        if (options.contains(.headers)) {
            if let mHeaders = headers, !mHeaders.isEmpty {
                components.append(contentsOf: mHeaders.map { "[\($0) : \($1)]" })
            } else {
                components.append("No Headers")
            }
        }
        if (options.contains(.body)) {
            if let mBody = body {
                if let str = String(data: mBody, encoding: .utf8) {
                    components.append(str)
                } else {
                    components.append("Binary body: \(mBody.count) bytes")
                }
            } else {
                components.append("No Body.")
            }
        }
        onLog?(components.joined(separator: "\n"))
    }
}
