import XCTest

@testable import SSSugarCore

/// # Cases:
/// **bodyFromArgs**
/// * _regular_ – proxies call to converter
/// * _nil_ – doesn't proxy call to converter
/// * _rethrows_ – rethrows converter error
/// **tryParseArgs**
/// * _regular_ – proxies call to converter
/// * _nil_ – returns nil on exception
///
class SSApiCallOptionstTests: XCTestCase {
    var sut: SSApiCallOptions!
    var converter: TestConverter!
    
    override func setUp() {
        converter = TestConverter()
        sut = SSApiCallOptions(baseURL: URL(string: "ukr.net")!, headers: [:], argsConverter: converter)
    }
    
    //MARK: - bodyFromArgs
    
    func testDataRegular() {
        let data = try! sut.bodyFromArgs([:])
        
        checkData(data)
    }
    
    func testDataNil() {
        let data = try! sut.bodyFromArgs(nil)
        
        checkData(data, expected: nil, dataCount: 0)
    }
    
    func testDataRethrows() {
        converter.error = TestError.data
        
        func job() throws {
            let _ = try sut.bodyFromArgs([:])
        }
        
        assertError(job: job) {
            if case .data = $0 as? TestError {
                return true
            }
            return false
        }
    }
    
    //MARK: - tryParseArgs
    
    func testParseArgsRegular() {
        let args = sut.tryParseArgs(converter.data)
        
        checkArgs(args, expected: converter.args)
    }
    
    
    func testParseArgsNil() {
        converter.error = TestError.args
        
        let args = sut.tryParseArgs(converter.data)
        
        checkArgs(args, expected: nil)
    }
    
    //MARK: - private
    
    func checkData(_ data: Data?, expected: Data?, dataCount: Int = 1, argsCount: Int = 0) {
        XCTAssertEqual(converter.callCount.data, dataCount)
        XCTAssertEqual(converter.callCount.args, argsCount)
        XCTAssertEqual(data, expected)
    }
    
    func checkData(_ data: Data?, dataCount: Int = 1, argsCount: Int = 0) {
        checkData(data, expected: converter.data, dataCount: dataCount, argsCount: argsCount)
    }
    
    func checkArgs(_ args: [String : Any]?, expected: [String : String]?, dataCount: Int = 0, argsCount: Int = 1) {
        XCTAssertEqual(converter.callCount.data, dataCount)
        XCTAssertEqual(converter.callCount.args, argsCount)
        XCTAssertEqual(args as? [String : String], expected)
    }
    
    //MARK: - helpers
    
    enum TestError: Error {
        case data
        case args
    }
    
    class TestConverter: SSApiArgsConverting {
        var contentType = SSApiContentType.json
        
        var callCount = (data: 0, args: 0)
        var args: [String : String]
        var data: Data
        var error: Error? = nil
        
        init() {
            args = ["test_arg_key" : "test_arg_key"]
            data = "test_data".data(using: .utf8)!
        }
        
        func data(from args: [String : Any]) throws -> Data {
            callCount.data += 1
            if let mError = error { throw mError }
            return data
        }
        
        func args(from data: Data?) throws -> Args {
            callCount.args += 1
            if let mError = error { throw mError }
            return args
        }
    }
}
