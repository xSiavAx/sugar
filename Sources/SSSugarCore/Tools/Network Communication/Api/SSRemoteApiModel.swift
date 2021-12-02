import Foundation

#warning("TODO: Api Model")
//Try to improove using Codable
//https://habr.com/ru/post/414221/

/// Api callback response that represents `success` or `fail` options.
///
/// # Generics:
/// * `Entity` - type of model that passed to callback in `success` case.
/// * `CommonError` – type of common api error component, used as corresponding generic of `ApiError` in `fail` case.
/// * `SpecificError` – type of specific api error component, used as corresponding generic of `ApiError` in `fail` case.
public enum SSApiResponse<Entity, CommonError: Error, SpecificError: Error> {
    case success(entity: Entity)
    case fail(error: SSApiError<CommonError, SpecificError>)
}

#warning("TODO Communicator")
//TODO: Add `throw` to `func entity() -> Entity` (or optional return) to process `cantParse` case insteaf of fatal error. Cuz unexpected server behaviour when it returns accepable status, no error that may be parsed via `func error() -> IError?` but arguments that don't allow to build Entity.

/// Requirements for Remote Api Model tool.
///
/// Usually ApiModel takes care of some Api call – prepares data for request building (`contentType`, `path`, `args()`) and parses data from response (`response`, `error()`, `entity()`).
///
/// - Important: To avoid code dublication use methods provided by extsnsion.s
///
/// # Extension:
/// `processWith(communicator:options:handler:)` – builds request, run communication task and handle response.
public protocol SSRemoteApiModel: AnyObject {
    /// Type of model that should parsed from response in `success` case.
    associatedtype Entity
    /// Type of common api error component, used as corresponding generic of `ApiError` in `fail` case.
    associatedtype CommonError: Error
    /// Type of specific api error component, used as corresponding generic of `ApiError` in `fail` case.
    associatedtype SpecificError: Error
    
    /// Request and Response arguments Type shortcut
    typealias Args = [String : Any]
    /// Api error Type shortcut
    typealias IError = SSApiError<CommonError, SpecificError>
    /// Response Type shortcut
    typealias Response = SSApiResponse<Entity, CommonError, SpecificError>
    
    /// Api path used for to create building Request's URL
    var path: String {get}
    /// Response data aquired from Communictaor.
    ///
    /// Property fills in extension method `processWith(communicator:options:handler:)` to store data. Also should be used within `entity()` to get data from.
    var response: (addon: SSResponseAdditionData?, args: Args?) {get set}
    
    /// Creates arguments to convert to body data of building Request's
    func args() -> Args
    /// Creates Api error based on stored response.
    func error() -> IError?
    /// Creates Entity based on stored response.
    func entity() -> Entity
}

public extension SSRemoteApiModel {
    /// Request's field key for Content Type value
    static var contentTypeKey: String {"Content-Type"}
    
    /// Creates Request arguments, creates and prefroms network task via passed communicator, handles response. Creates and passes to handler Api `.call` error in case of failed request. Creates and passes to handler Entity in case of successed request.
    /// - Parameters:
    ///   - communicator: Communicator to prefrom network task.
    ///   - options: Api call options.
    ///   - handler: Processing handler.
    ///   - response: Api response.
    /// - Returns: Created task created by communicator on `runTask(url:headers:body:handler:)` call.
    /// - Throws: Rethrows errors from injected args converter
    @discardableResult
    func processWith(communicator: SSCommunicating, options: SSApiCallOptions, handler: @escaping (_ response: Response)->Void) throws -> SSCommunicatingTask {
        let url = options.baseURL.appendingPathComponent(path)
        let body = try options.bodyFromArgs(args())
        var headers = options.headers

        func onFinish(data: Data?, addon: SSResponseAdditionData?, error: SSCommunicatorError?) {
            response = (addon, nil)
            defer { response = (nil, nil) }
            
            if let apiError = apiNonParseErrorFrom(commError: error) ?? parseArgs(options: options, data: data, communicationError: error) {
                handler(.fail(error: apiError))
            } else {
                handler(.success(entity: entity()))
            }
        }
        headers[Self.contentTypeKey] = options.contentType.rawValue
        
        return communicator.runTask(url: url, headers:headers, body: body, acceptableStatuses: options.acceptableStatuses, handler: onFinish)
    }
    
    //MARK: private
    
    private func responseFrom() -> Response {
        if let error = error() {
            return .fail(error: error)
        }
        return .success(entity: entity())
    }
    
    private func apiNonParseErrorFrom(commError: SSCommunicatorError?) -> IError? {
        switch commError {
        case .noConnection:
            return .call(cause:.noConnection)
        case .badCertificates:
            return .call(cause:.badCertificates)
        case .libError(let sdkError):
            return .call(cause:.libError(libError: sdkError))
        case .unexpectedStatus, nil:
            return nil
        }
    }
    
    private func parseArgs(options: SSApiCallOptions, data: Data?, communicationError: SSCommunicatorError?) -> IError? {
        do {
            response.args = try options.argsConverter.args(from: data)
            
            if let error = error() {
                //That logic may not works if server returns `200 OK` and invalid error in arguments (unexpected type, or value that doesn't match any error).
                return error
            }
            switch communicationError {
            case .unexpectedStatus:
                return .call(cause: .unexpected(data: data, args: response.args, commError: communicationError))
            case .noConnection, .badCertificates, .libError, nil:
                return nil
            }
        } catch {
            return .call(cause: .unexpected(data: data, args: nil, commError: communicationError))
        }
    }
}
