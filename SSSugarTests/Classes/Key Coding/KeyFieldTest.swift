import XCTest

@testable import SSSugar

/// # Cases:
/// _init_ - initializes with passed params
/// _initDefaults_ - initializes with default params
/// _parse_ - reads val from storage (fields with different types including optional)
/// _write_ - writes val to storage (fields with different types including optional)
/// _adaper_ - uses adapter on read and write
/// _defaultValue_ - returns default value on nil in storage
/// _writeDefault_ - writes default value to storage
/// _writeDefaultAdapter_ - applies adapter on write default value to storage
/// _writeDefaultNotNeeded_ - doesn't write default value to storage if it already contains one
class SSKeyFieldTest: XCTestCase {
    //MARK: - Cases
    func testInit() {
        let adapter = DummyAdapter()
        let field = SSKeyField<Int>("some", 42, adapter: adapter)
        
        XCTAssertEqual(field.title, "some")
        XCTAssertEqual(field.defaultValue, 42)
        XCTAssert(field.adapter === adapter)
    }
    
    func testInitDefault() {
        let field1 = SSKeyField<Int>("some", 42)
        let field2 = SSKeyField<Int>("another", adapter: DummyAdapter())
        
        XCTAssertEqual(field1.title, "some")
        XCTAssertNil(field1.adapter)
        XCTAssertEqual(field2.title, "another")
        XCTAssertNil(field2.defaultValue)
    }
    
    func testParse() {
        let fields = dummyFields()
        
        let args: [String : Any] = dummyArgs()
        let storage: [String : Any] = [fields.val.title : 123, fields.args.title : args]
        
        XCTAssertEqual(fields.val.parse(storage), 123)
        XCTAssert(isDummyArgs(args, equalsTo: fields.args.parse(storage)))
        XCTAssertEqual(fields.opt.parse(storage), nil)
    }
    
    func testWrite() {
        let fields = dummyFields()
        let args: [String : Any] = dummyArgs()
        var result: SSKeyFieldStorage = [fields.opt.title : 12]
        
        fields.val.write(to: &result, val: 123)
        fields.args.write(to: &result, val: args)
        fields.opt.write(to: &result, val: nil)
        
        XCTAssertEqual(result[fields.val.title] as? Int, 123)
        XCTAssert(isDummyArgs(args, equalsTo: result[fields.args.title] as? [String : Any]))
        XCTAssertNil(result[fields.opt.title])
    }
    
    func testAdapter() {
        let field = SSKeyField<Date>("date", adapter: SSKeyFieldConverter.dateIntAdapter())
        let time = dummyDate()
        var storage: SSKeyFieldStorage = [field.title : Int(time.timeIntervalSince1970)]

        XCTAssertEqual(time, field.parse(storage))
        storage[field.title] = 0

        field.write(to: &storage, val: time)
        XCTAssertEqual(storage[field.title] as? Int, Int(time.timeIntervalSince1970))
    }

    func testDefaultValue() {
        let field = SSKeyField<Int>("some", 42)

        XCTAssertEqual(field.parse([:]), 42)
    }

    func testWriteDefault() {
        var storage: SSKeyFieldStorage = [String: Any]()
        let field = SSKeyField<Int>("some", 42)

        field.writeDefaultIfNeeded(to: &storage)

        XCTAssertEqual(storage[field.title] as? Int, 42)
    }
    
    func testWriteDefaultAdapter() {
        let time = dummyDate()
        let field = SSKeyField<Date>("date", time, adapter: SSKeyFieldConverter.dateIntAdapter())
        var storage: SSKeyFieldStorage = [String: Any]()

        field.writeDefaultIfNeeded(to: &storage)

        XCTAssertEqual(storage[field.title] as? Int, Int(time.timeIntervalSince1970))
    }

    func testWriteDefaultNotNeeded() {
        var storage: SSKeyFieldStorage = ["some" : 88]
        let field = SSKeyField<Int>("some", 42)

        field.writeDefaultIfNeeded(to: &storage)

        XCTAssertEqual(storage[field.title] as? Int, 88)
    }
    
    //MARK: - Private

    private func dummyFields() -> (val: SSKeyField<Int>, args: SSKeyFieldObj, opt: SSKeyField<Int?>) {
        return (SSKeyField<Int>("val"),
                SSKeyFieldObj("args"),
                SSKeyField<Int?>("not_key"))
    }
    
    private func dummyArgs() -> [String : Any] {
        return ["arg1" : 1, "arg2" : "2"]
    }
    
    private func dummyDate() -> Date {
        let ts = Int(Date().timeIntervalSince1970)
        return Date(timeIntervalSince1970: Double(ts))
    }
    
    private func isDummyArgs(_ left: [String : Any], equalsTo mRight: [String : Any]?) -> Bool {
        guard let right = mRight else { return false }
        return left.count == right.count
        && left["arg1"] as? Int == right["arg1"] as? Int
        && left["arg2"] as? String == right["arg2"] as? String
    }
    
    class DummyAdapter: SSKeyField<Int>.Adapter {}
}
