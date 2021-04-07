import XCTest

@testable import SSSugarCore

/// # Cases:
/// ** processWith **
/// Options should check args convertings call
/// Communicator should checks passed URL, data is equal to expected one, headers are same as options plus Content Type.
/// Each case should check headers and args.
/// * _regular_ - makes call and passing entity to handler
/// * _regularEmptyHeaders_ - makes call (with empty headers) and passing entity to handler
/// * _callErrorNoConnection_ - creates call error on .noConnection
/// * _callErrorBadCertificates_ - creates call error on .badCertificate
/// * _callErrorLibError_ - creates call error on .libError
/// * _callErrorUnexpectedDueBadParse_ - creates call error on exception thorwn from args converter
/// * _callErrorUnexpectedDueBadStatus_ - creates call error on bad status and no error parsed
/// * _error_ - passes error to handler on one parsed from args
/// * _errorEvenWithBadStatus_ - pass error to handler even with bad status
/// * _throws_ – rethrows error from args converter
class SSRemoteApiTests: XCTestCase {
    static var defaultRequestHeaders = ["request_header_key" : "request_header_value"]
    static var defaultResponseHeaders = ["response_header_key" : "response_header_value"]
    static var defaultArguments = ["request_arg_key" : "request_arg_val"]
    static var defaultPath = "some/default_path"
    static var baseURL = URL(string: "https://test.remote.api")!
    
    var converter: ArgConverter!
    var options: SSApiCallOptions!
    var api: TestApi!
    var communicator: Communicator!
    var failCheck: ((SSApiError<TestCommonError, TestSpecificError>)->Bool)?
    
    override func setUp() {
        func onCheck(condition: Bool) { XCTAssert(condition) }
        
        converter = ArgConverter()
        options = SSApiCallOptions(baseURL: Self.baseURL, headers: Self.defaultRequestHeaders, argsConverter: converter)
        api = TestApi(path: Self.defaultPath, arguments: Self.defaultArguments, onCheck: onCheck)
        communicator = Communicator(onCheck: onCheck)
    }
    
    override func tearDown() {
        converter = nil
        options = nil
        api = nil
        failCheck = nil
    }
    
    func testRegular() {
        let expected = TestEnity(title: "test_entity")
        let args = [TestApi.titleKey : expected.title]
        
        configComponents(response: args)
        
        check(expected: expected)
    }
    
    func testRegularEmptyHeaders() {
        let expected = TestEnity(title: "test_entity")
        let args = [TestApi.titleKey : expected.title]
        
        options.headers = [:]
        
        configComponents(response: args)
        
        check(expected: expected)
    }
    
    func testCallErrorNoConn() {
        configComponents(error: .noConnection)
        
        failCheck = {
            if case let .call(cause) = $0, case .noConnection = cause {
                return true
            }
            return false
        }
        
        check()
    }
    
    func testCallBadCertificates() {
        configComponents(error: .badCertificates)
        
        failCheck = {
            if case let .call(cause) = $0, case .badCertificates = cause {
                return true
            }
            return false
        }
        
        check()
    }
    
    func testCallLibError() {
        configComponents(error: .libError(libError: TestError.library))
        
        failCheck = {
            if case let .call(cause) = $0, case let .libError(libError) = cause, case .library = libError as? TestError {
                return true
            }
            return false
        }
        
        check()
    }
    
    func testUnexpectedDueBadParse() {
        let args = ["dummy_key" : "never_uses"]
        
        converter.argsError = TestError.converting
        
        configComponents(response: args)
        
        failCheck = {[weak self] in
            if case let .call(cause) = $0, case let .unexpected(data, args, error) = cause {
                return data == self?.communicator.response && args == nil && error == nil
            }
            return false
        }
        
        check()
    }
    
    func testUnexpectedDueBadStatus() {
        let args = ["dummy_key" : "never_uses"]
        
        configComponents(response: args, error: .unexpectedStatus(status: 599))
        
        failCheck = {[weak self] in
            if case let .call(cause) = $0, case let .unexpected(data, mArgs, error) = cause, case let .unexpectedStatus(code) = error as? SSCommunicatorError {
                return data == self?.communicator.response && mArgs as? [String : String] == args && code == 599
            }
            return false
        }
        
        check()
    }
    
    func testError() {
        let args = [TestApi.errorKey : TestApi.specificError]
        
        configComponents(response: args)
        
        failCheck = {
            if case .specific = $0 {
                return true
            }
            return false
        }
        check()
    }
    
    func testErrorEvenWithBadStatus() {
        let args = [TestApi.errorKey : TestApi.specificError]
        
        configComponents(response: args, error: .unexpectedStatus(status: 599))
        
        failCheck = {
            if case .specific = $0 {
                return true
            }
            return false
        }
        check()
    }
    
    func testRethrows() {
        converter.dataError = TestError.converting
        
        func job() throws {
            try api.processWith(communicator: communicator, options: options) {(response) in
                XCTAssert(false, "Shouldn't call")
            }
        }
        assertError(job: job) {
            if case .converting = $0 as? TestError {
                return true
            }
            return false
        }
    }
    
    //MARK: - private
    func check(expected: TestEnity? = nil) {
        func job(exp: XCTestExpectation) {
            func check(result: TestApi.Response) {
                switch result {
                case .success(let entity):
                    XCTAssertEqual(expected, entity)
                    XCTAssert(failCheck == nil)
                case .fail(let error):
                    XCTAssert(failCheck!(error))
                    XCTAssertNil(expected)
                }
            }
            try! api.processWith(communicator: communicator, options: options) {
                exp.fulfill()
                check(result: $0)
            }
        }
        wait(on: job(exp:))
    }
    
    func configComponents(response: [String : Any] = [:], error: SSCommunicatorError? = nil) {
        configCommunicator(response: response, error: error)
        configCommunicatorExpectation()
        configApiExpectation()
    }
    
    func configCommunicator(response: [String : Any] = [:], error: SSCommunicatorError? = nil) {
        let data = converter.dataIgnoringError(from: response)

        communicator.response = data
        communicator.error = error
    }
    
    func configCommunicatorExpectation() {
        communicator.configExpectingWith(options: options, path: api.path, args: api.arguments)
    }
    
    func configApiExpectation() {
        let args = converter.argsIgnoringError(from: communicator.response)
        api.expected = (communicator.responseHeaders as? [String : String], args as? [String : String])
    }
    
    //MARK: - Helpers
    
    struct TestEnity: Equatable {
        var title: String
    }
    
    enum TestCommonError: Error {
        case common
    }
    
    enum TestSpecificError: Error {
        case specific
    }
    
    class Communicator: SSCommunicating {
        var expected: (url: URL, body: Data, headers: [String : String])?
        var response: Data!
        var responseHeaders: [AnyHashable : Any]!
        var error: SSCommunicatorError?
        var check: (Bool)->Void
        
        class DummyTask: SSCommunicatingTask {
            var finished: Bool { get {true} }
            
            func cancel() {}
        }
        
        init(onCheck: @escaping (Bool)->Void) {
            check = onCheck
        }
        
        @discardableResult
        func configExpectingWith(options: SSApiCallOptions, path: String, args: [String : Any]) -> Communicator {
            if let body = try? options.bodyFromArgs(args) {
                let url = options.baseURL.appendingPathComponent(path)
                let headers = options.headers.merging([TestApi.contentTypeKey : SSApiContentType.json.rawValue])
                
                expected = (url, body, headers)
            }
            
            return self
        }
        
        func runTask(url: URL, headers: [String : String]?, body: Data?, handler: @escaping Handler) -> SSCommunicatingTask {
            check(url == expected?.url)
            check(body == expected?.body)
            check(headers == expected?.headers)
            
            func onBg() {
                handler(response, responseHeaders, error)
            }
            
            DispatchQueue.bg.async(execute: onBg)
            return DummyTask()
        }
    }
    
    class TestApi: SSRemoteApiModel {
        static let titleKey = "entity_title"
        static let errorKey = "error"
        static let commonError = "common_error"
        static let specificError = "specific_error"
        
        var contentType: SSApiContentType { .json }
        var response: (headers: Headers?, args: Args?)
        var arguments: Args
        var expected: (headers: [String : String]?, args: [String : String]?)
        
        var path: String
        var check: (Bool)->Void
        
        init(path mPath: String, arguments mArguments: Args, onCheck: @escaping (Bool)->Void) {
            path = mPath
            arguments = mArguments
            check = onCheck
        }
        
        func args() -> Args {
            return arguments
        }
        
        func entity() -> TestEnity {
            checkArgsAndHeaders()
            return TestEnity(title: response.args![Self.titleKey] as! String)
        }
        
        func error() -> SSApiError<TestCommonError, TestSpecificError>? {
            checkArgsAndHeaders()
            switch response.args![Self.errorKey] as? String {
            case Self.specificError: return .specific(cause: .specific)
            case Self.commonError: return .common(cause: .common)
            default: return nil
            }
        }
        
        func checkArgsAndHeaders() {
            check(expected.headers == response.headers as? [String : String])
            check(expected.args == response.args as? [String : String])
        }
    }
        
    class ArgConverter: SSApiArgsConverting {
        var contentType = SSApiContentType.json
        
        enum ConvertError: Error {
            case convert
        }
        var dataError: Error?
        var argsError: Error?
        var nilData = false
        
        func data(from args: [String : Any]) throws -> Data {
            if let mError = dataError { throw mError }
            return dataIgnoringError(from: args)
        }
        
        func args(from data: Data?) throws -> [String : Any] {
            if let mError = argsError { throw mError }
            return argsIgnoringError(from: data)
        }
        
        func dataIgnoringError(from args: [String : Any]) -> Data {
            return try! JSONSerialization.data(withJSONObject: args, options: [.prettyPrinted])
        }
        
        func argsIgnoringError(from data: Data?) -> [String : Any] {
            return try! JSONSerialization.jsonObject(with: data!) as! [String : Any]
        }
    }
    
    enum TestError: Error {
        case library
        case converting
    }
}
