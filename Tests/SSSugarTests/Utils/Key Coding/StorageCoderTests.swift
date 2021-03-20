import XCTest

@testable import SSSugar

/// # Cases:
/// _init_ - initializes with passed dict
/// _initDefault_ - initializes with empty dict
/// _initRooted_ - initializes parsing dict
/// _dict_ - converts storage to dict
/// _writeRooted_ - writes dict to passed one
/// _bindPropOwner_ - calls after init
/// _setup_ - set self as owner for passed field
/// _setupOnInit_ - check setup calls within inheritor `bindPropOwner` has called after init. This test case isn't necessary due to _bindPropOwner_ and _bindPropOwner_, but inheritance case is mostly used, thats why this case are exist.
/// _initRootedError_ - initializes parsing dict with no coresponding sub-dict (fatal error)
class StorageCoderTests: XCTestCase {
    func testInit() {
        let dict = dummyDict()
        let coder = SSStorageCoder(dict: dict)
        
        XCTAssert(isDummyDict(dict, equalsTo: coder.dict()))
    }
    
    func testDefaultInit() {
        let coder = SSStorageCoder()
        
        XCTAssert(coder.dict().isEmpty)
    }
    
    func testInitRooted() {
        let root = dummyDict()
        let dict = ["root" : root]
        let coder = RootedStorage(parse: dict)
        
        XCTAssert(isDummyDict(root, equalsTo: coder.dict()))
    }
    
    func testDict() {
        let coder = SSStorageCoder()
        
        coder.storage["int"] = 42
        coder.storage["str"] = "42"
        coder.storage["opt"] = nil
        
        let dict = coder.dict()
        
        XCTAssertEqual(dict.count, 2)
        XCTAssertEqual(dict["int"] as? Int, 42)
        XCTAssertEqual(dict["str"] as? String, "42")
    }
    
    func testWriteRooted() {
        let root = dummyDict()
        let dict = ["root" : root]
        var result: SSKeyFieldStorage = [String : Any]()
        let coder = RootedStorage(parse: dict)
        
        coder.wtite(to: &result)
        
        XCTAssert(isDummyDict(dict, equalsTo: result as? [String : Any]))
    }
    
    func testBindPropOwner() {
        let coder = BindCheckStorage()
        
        XCTAssert(coder.binded)
    }
    
    func testSetup() {
        let fields = Fileds()
        let coder = SSStorageCoder()
        
        fields.setup(coder: coder)

        XCTAssert(fields.hasOwner(coder))
    }
    
    func testSetupAsInheritor() {
        let dict: [String : Any] = ["int" : 42, "str" : "42", "opt" : 88]
        let coder = TestStorage(dict: dict)
        
        XCTAssertEqual(coder.intField, 42)
        XCTAssertEqual(coder.strField, "42")
        XCTAssertEqual(coder.optField, 88)
        
        coder.intField = 12
        coder.strField = "12"
        coder.optField = nil
        
        XCTAssertEqual(coder.intField, 12)
        XCTAssertEqual(coder.strField, "12")
        XCTAssertEqual(coder.optField, nil)
        
        let result = coder.dict()
        
        XCTAssert(result.count == 2)
        XCTAssertEqual(result["int"] as? Int, 12)
        XCTAssertEqual(result["str"] as? String, "12")
        XCTAssertNil(result["opt"] )
    }
  
// Fatal error as expected
//    func testInitRootedNil() {
//        let dict = [String : Any]()
//        let coder = RootedStorage(parse: dict)
//
//        XCTAssert(coder.dict().isEmpty)
//    }

    private func dummyDict() -> [String : Any] {
        return ["arg1" : 1, "arg2" : "2"]
    }
    
    private func isDummyDict(_ left: [String : Any], equalsTo mRight: [String : Any]?) -> Bool {
        guard let right = mRight else { return false }
        return left.count == right.count
        && left["arg1"] as? Int == right["arg1"] as? Int
        && left["arg2"] as? String == right["arg2"] as? String
    }
    
    class RootedStorage: SSStorageCoder, SSRootedStorageCoding {
        static var root = SSKeyFieldObj("root")
    }
    
    class BindCheckStorage: SSStorageCoder {
        var binded = false
        
        override func bindPropOwner() {
            binded = true
        }
    }
    
    class Fileds {
        @SSKeyStoring("int") var intField: Int
        @SSKeyStoring("str") var strField: String
        @SSKeyStoring("opt") var optField: Int?
        
        func setup(coder: SSStorageCoder) {
            coder.setup(&_intField)
            coder.setup(&_strField)
            coder.setup(&_optField)
        }
        
        func hasOwner(_ coder: SSStorageCoder) -> Bool {
            return _intField.owner === coder && _strField.owner === coder && _optField.owner === coder
        }
    }
    
    class TestStorage: SSStorageCoder {
        @SSKeyStoring("int") var intField: Int
        @SSKeyStoring("str") var strField: String
        @SSKeyStoring("opt") var optField: Int?
        
        override func bindPropOwner() {
            setup(&_intField)
            setup(&_strField)
            setup(&_optField)
        }
    }
}
