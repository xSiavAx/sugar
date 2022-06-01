import XCTest

@testable import SSSugarCore
@testable import SSSugarKeyCoding

/// # Cases:
/// _access_ – access to dict val via property
/// _emptyInit_ – access to property with empty onwer's dict
/// _initWithAnotherKey_ – access to roperty with no value in owner's dict
/// _defaultValue_ – uses default property value on no value in owner's dict
/// _defaultValueNotUsed_ – uses property value (instead of default)
/// _defaultValueAfterClear_ – uses default property value after removing value from dict
/// _writeOnInit_ – writes default property value to owner's dict on init
/// _writeOnInitNotUsed_ – donesnt write default property value to owner's dict if dict already has value
/// _mutate_ – mutate dict val via property

class DictCodingWrapperTest: XCTestCase {
    func testAccess() {
        let userInt = RegularOwner<SomeTitle, Int>([SomeTitle.title : 412])
        let userStr = RegularOwner<SomeTitle, String>([SomeTitle.title : "412"])

        XCTAssertEqual(userInt.prop, 412)
        XCTAssertEqual(userStr.prop, "412")
    }
    
    func testEmptyInit() {
        let user = RegularOwner<SomeTitle, Int?>()

        XCTAssertNil(user.prop)
    }
    
    func testInitWithAnotherKey() {
        let user = RegularOwner<SomeTitle, Int?>([AnotherTitle.title : 412])

        XCTAssertNil(user.prop)
    }
    
    func testDefaultValue() {
        let owner = DefaultOwner<SomeTitle, Int42Default>()
        
        XCTAssertEqual(owner.prop, 42)
        XCTAssertNil(owner.storage[SomeTitle.title])
    }
    
    func testDefaultValueNotUsed() {
        let owner = DefaultOwner<SomeTitle, Int42Default>([SomeTitle.title : 88])
        
        XCTAssertEqual(owner.prop, 88)
    }
    
    func testDefaultAfterClear() {
        let owner = DefaultOwner<SomeTitle, Int42Default>([SomeTitle.title : 88])
        
        XCTAssertEqual(owner.prop, 88)
        owner.storage[SomeTitle.title] = nil
        XCTAssertEqual(owner.prop, 42)
    }
    
    func testWriteOnInit() {
        let owner = DefaultOwner<SomeTitle, Int42DefaultWrite>()
        
        XCTAssertEqual(owner.storage[SomeTitle.title] as! Int, 42)
        XCTAssertEqual(owner.prop, 42)
    }
    
    func testWriteOnInitNotUseds() {
        let owner = DefaultOwner<SomeTitle, Int42DefaultWrite>([SomeTitle.title : 88])
        
        XCTAssertEqual(owner.storage[SomeTitle.title] as! Int, 88)
        XCTAssertEqual(owner.prop, 88)
    }
    
    func testMutate() {
        let userInt = RegularOwner<SomeTitle, Int>()
        let userStr = RegularOwner<SomeTitle, String>([SomeTitle.title : "0"])
        let userNilOrInt = RegularOwner<SomeTitle, Int?>([SomeTitle.title : 88])
        
        userInt.prop = 412
        userStr.prop = "412"
        userNilOrInt.prop = nil

        XCTAssertEqual(userInt.prop, 412)
        XCTAssertEqual(userStr.prop, "412")
        XCTAssertNil(userNilOrInt.prop)
    }
    
//        Fatal error
//        func testEmptyInitFatalError() {
//            let user = WrapperUser<Int, SomeTitle>()
//
//            user.prop == 0
//        }
    
    class PropertyOwner: SSKeyStoringOwner {
        var storage: SSKeyFieldStorage

        init(_ mDict: [String : Any]) {
            storage = mDict
        }
    }
    
    class RegularOwner<Title: PropertyOwnerTitle, T>: PropertyOwner {
        @SSKeyStoring(Title.title) var prop: T
        
        override init(_ mDict: [String : Any] = [:]) {
            super.init(mDict)
            _prop.owner = self
        }
    }
    
    class DefaultOwner<Title: PropertyOwnerTitle, Default: PropertyOwnerDefault>: PropertyOwner {
        typealias T = Default.T
        
        @SSKeyStoring(Title.title, Default.value, writeOnStart: Default.writeOnInit) var prop: T
        
        override init(_ mDict: [String : Any] = [:]) {
            super.init(mDict)
            _prop.owner = self
        }
    }
    
    class SomeTitle: PropertyOwnerTitle {
        static let title = "some"
    }
    
    class AnotherTitle: PropertyOwnerTitle {
        static let title = "another"
    }
    
    class Int42Default: PropertyOwnerDefault {
        static var value: Int = 42
        static var writeOnInit: Bool = false
    }
    
    class Int42DefaultWrite: PropertyOwnerDefault {
        static var value: Int = 42
        static var writeOnInit: Bool = true
    }
}

protocol PropertyOwnerTitle {
    static var title: String {get}
}

protocol PropertyOwnerDefault {
    associatedtype T
    static var value: T {get}
    static var writeOnInit: Bool {get}
}

