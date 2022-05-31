import XCTest

@testable import SSSugarCore

/// # Cases:
/// **onRead**
/// _onCommon_ - calls `common` component build and `specific` doesn't call
/// _onSpecific_ - calls `specific` calls on `common` returns `nil`
/// _unexpected_ - returns `unexpected` common error on both closures returns `nil`
/// _nil_ - returns `nil` on input is `nil`
///
/// **parser**
/// Check closures of created Adapter, `write` is nil and `read` satisfy all **onRead** cases.
///
/// **parser with Common or Specific conform ApiErrorCause**
/// Check closures of created Adapter, `write` is nil and `read` satisfy all **onRead** cases.
///
class ApiErrorConverterTests: XCTestCase {
    typealias Converter = SSApiErrorConverter<TestError, TestError>
    typealias CommonCausedConverter = SSApiErrorConverter<TestErrorCaused, TestError>
    typealias SpecificCausedConverter = SSApiErrorConverter<TestError, SpecificErrorCaused>
    
    var tester: Tester!
    
    override func setUp() {
        func check(condition: Bool) {
            XCTAssert(condition)
        }
        tester = Tester(check: check)
    }
    
    override func tearDown() {
        tester = nil
    }
    
    //MARK: - OnRaad
    
    func testOnReadCommon() {
        let onRead = Self.converterOnRaad()
        
        tester.common(sut: onRead)
    }
    
    func testOnReadSpecific() {
        let onRead = Self.converterOnRaad()
        
        tester.specific(sut: onRead)
    }
    
    func testOnReadUnexpected() {
        let onRead = Self.converterOnRaad()
        
        tester.unexpected(sut: onRead)
    }
    
    func testOnReadNil() {
        let onRead = Self.converterOnRaad()
        
        tester.onNil(sut: onRead)
    }
    
    //MARK: - Parser
    
    func testParserCommon() {
        let parser = Self.converterParser()
        
        XCTAssertNil(parser.write)
        tester.common(sut: parser.read!)
    }
    
    func testParserSpecific() {
        let parser = Self.converterParser()
        
        XCTAssertNil(parser.write)
        tester.specific(sut: parser.read!)
    }
    
    func testParserUnexpected() {
        let parser = Self.converterParser()
        
        XCTAssertNil(parser.write)
        tester.unexpected(sut: parser.read!)
    }
    
    func testParserNil() {
        let parser = Self.converterParser()
        
        XCTAssertNil(parser.write)
        tester.onNil(sut: parser.read!)
    }
    
    //MARK: - Parser with Common conforms ApiErrorCause
    
    func testCommonCauseParserCommon() {
        let parser = Self.commonCauseParser()
        
        tester.common(sut: parser.read!)
    }
    
    func testCommonCauseParserSpecific() {
        let parser = Self.commonCauseParser()
        
        tester.specific(sut: parser.read!)
    }
    
    func testCommonCauseParserUnexpected() {
        let parser = Self.commonCauseParser()
        
        tester.unexpected(sut: parser.read!)
    }
    
    func testCommonCauseParserNil() {
        let parser = Self.commonCauseParser()
        
        tester.onNil(sut: parser.read!)
    }
    
    //MARK: - Parser with Specific conforms ApiErrorCause
    
    func testSpecificCauseParserCommon() {
        let parser = Self.specificCauseParser()
        
        tester.common(sut: parser.read!)
    }
    
    func testSpecificCauseParserSpecific() {
        let parser = Self.specificCauseParser()
        
        tester.specific(sut: parser.read!)
    }
    
    func testSpecificCauseParserUnexpected() {
        let parser = Self.specificCauseParser()
        
        tester.unexpected(sut: parser.read!)
    }
    
    func testSpecificCauseParserNil() {
        let parser = Self.specificCauseParser()
        
        tester.onNil(sut: parser.read!)
    }
    
    //MARK: - Helpers
    
    private static func converterOnRaad() -> Converter.Adapter.Read {
        func buildCommon(input: String, storage: SSKeyFieldStorage) -> TestError? {
            return TestErrorCaused(rawValue: input)
        }
        func buildSpecific(input: String, storage: SSKeyFieldStorage) -> TestError? {
            return SpecificErrorCaused(rawValue: input)
        }
        return Converter.onRead(buildCommon: buildCommon, buildSpecific: buildSpecific)
    }
    
    private static func converterParser() -> Converter.Adapter {
        func buildCommon(input: String, storage: SSKeyFieldStorage) -> TestError? {
            return TestErrorCaused(rawValue: input)
        }
        func buildSpecific(input: String, storage: SSKeyFieldStorage) -> TestError? {
            return SpecificErrorCaused(rawValue: input)
        }
        return Converter.parser(buildCommon: buildCommon, buildSpecific: buildSpecific)
    }
    
    private static func commonCauseParser() -> CommonCausedConverter.Adapter {
        func buildSpecific(input: String, storage: SSKeyFieldStorage) -> TestError? {
            return SpecificErrorCaused(rawValue: input)
        }
        return CommonCausedConverter.parser(buildSpecific: buildSpecific)
    }
    
    private static func specificCauseParser() -> SpecificCausedConverter.Adapter {
        func buildCommon(input: String, storage: SSKeyFieldStorage) -> TestError? {
            return TestErrorCaused(rawValue: input)
        }
        return SpecificCausedConverter.parser(buildCommon: buildCommon)
    }
    
    struct Tester {
        var storage: SSKeyFieldStorage = [String : Any]()
        var key: String = "key"
        
        var check: (Bool)->Void

        func common<C: TestError, S: TestError>(sut: SSKeyField<SSApiError<C, S>?>.Adapter.Read) {
            let error = sut(storage, key, "common")
            
            switch error {
            case .common(let cause):
                XCTAssertEqual(cause.rawValue, "common")
            default:
                XCTAssert(false)
            }
        }
        
        func specific<C: TestError, S: TestError>(sut: SSKeyField<SSApiError<C, S>?>.Adapter.Read) {
            let error = sut(storage, key, "specific_error")
            
            switch error {
            case .specific(let cause):
                XCTAssertEqual(cause.rawValue, "specific_error")
            default:
                XCTAssert(false)
            }
        }
        
        func unexpected<C: TestError, S: TestError>(sut: SSKeyField<SSApiError<C, S>?>.Adapter.Read) {
            let error = sut(storage, key, "nil")
            
            XCTAssertNil(error)
        }
        
        func onNil<C: TestError, S: TestError>(sut: SSKeyField<SSApiError<C, S>?>.Adapter.Read) {
            let error = sut(storage, key, nil)
            
            XCTAssertNil(error)
        }
    }
    
    class TestError: Error {
        var rawValue: String
        
        init?(rawValue mRawValue: String) {
            rawValue = mRawValue
        }
    }
    
    class SpecificErrorCaused: TestError, SSStringRepresentableApiErrorComponent {
        required override init?(rawValue: String) {
            if (rawValue == "nil") {
                return nil
            }
            super.init(rawValue: rawValue)
        }
    }
    
    class TestErrorCaused: TestError, SSStringRepresentableApiErrorComponent {
        required override init?(rawValue: String) {
            if (rawValue.hasPrefix("specific") || rawValue == "nil") {
                return nil
            }
            super.init(rawValue: rawValue)
        }
    }
}
