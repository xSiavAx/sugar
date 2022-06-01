import XCTest

@testable import SSSugarCore
@testable import SSSugarKeyCoding

/// # Cases:
///
/// **String to Error**
/// - _build_ - build calls with right arg
/// - _fromNil_ - build calls with nil on nil passed
///
/// **String to**
/// - _build_ - write is nil, build calls with right arg on read calls
/// - _nil_ - build calls with nil on read calls
///
/// **String to with ApiErrorCreatable**
/// - _build_ - `.from()` calls with right arg
/// - _nil_ - `.from()` calls with nil
///
class SSErrorConverterTests: XCTestCase {
    var dummyStorage: SSKeyFieldStorage = [String : Any]()
    var dummyKey: String = "key"
    
    //MARK: - String to Error
    
    func testStringToErrorBuild() {
        let error = SSErrorConverter.stringToError(input: "test") { TestError(title: $0) }
        XCTAssertEqual(error?.title, "test")
    }
    
    func testStringToErrorNil() {
        let error = SSErrorConverter.stringToError(input: nil) { TestError(title: $0) }
        XCTAssertNil(error)
    }
    
    //MARK: - String to
    
    func testStringToBuild() {
        let adaper = SSErrorConverter.parser { TestError(title: $0) }
        let error = adaper.read?(dummyStorage, dummyKey, "test")
            
        XCTAssertNil(adaper.write)
        XCTAssertEqual(error?.title, "test")
    }
    
    func testStringToNil() {
        let adaper = SSErrorConverter.parser { TestError(title: $0) }
        let error = adaper.read?(dummyStorage, dummyKey, nil)
        
        XCTAssertNil(error)
    }
    
    //MARK: - String to with ApiErrorCreatable
    
    func testStringToCreatableBuild() {
        let adaper = SSErrorConverter<StringTestError>.parser()
        let error = adaper.read?(dummyStorage, dummyKey, "test")
            
        XCTAssertNil(adaper.write)
        XCTAssertEqual(error?.title, "test")
    }
    
    func testStringToCreatableNil() {
        let adaper = SSErrorConverter<StringTestError>.parser()
        let error = adaper.read?(dummyStorage, dummyKey, nil)
        
        XCTAssertNil(error)
    }
    
    //MARK: - Helpers
    
    class TestError: Error {
        let title: String
        
        init(title mTitle: String) {
            title = mTitle
        }
    }
    
    class StringTestError: TestError, SSStringRepresentableError {
        static func from(string: String) -> Self? {
            return StringTestError(title: string) as? Self
        }
    }
}
