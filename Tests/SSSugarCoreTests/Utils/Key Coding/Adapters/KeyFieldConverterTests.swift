import XCTest

@testable import SSSugarCore

/// # Cases:
/// **Date Int**
/// _read_
/// _write_
///
/// **UUID String**
/// _to_
/// _from_
///
class SSKeyFieldConverterTests: XCTestCase {
    var dummyStorage: SSKeyFieldStorage = [String : Any]()
    var dummyKey: String = "key"
    var dict: [String : Any] { dummyStorage as! [String : Any] }
    
    //MARK: - Int Date
    func testDateIntRead() {
        let adapter = SSKeyFieldConverter.dateIntAdapter()
        let params = dateAndTs()
        
        XCTAssertEqual(params.date, adapter.read?(dummyStorage, dummyKey, params.ts))
    }
    
    func testDateIntWrite() {
        let adapter = SSKeyFieldConverter.dateIntAdapter()
        let params = dateAndTs()
        
        XCTAssertEqual(params.ts, adapter.write?(&dummyStorage, dummyKey, params.date) as? Int)
        XCTAssert(dict.isEmpty)
    }
    
    private func dateAndTs() -> (date: Date, ts: Int) {
        let date = Date()
        let timestamp = Int(date.timeIntervalSince1970)
        let strictDate = Date(timeIntervalSince1970: Double(timestamp))
        
        return (strictDate, timestamp)
    }
    
    //MARK: - UUID String
    func testUUIDStrRead() {
        let adapter = SSKeyFieldConverter.uuidStringAdapter()
        let params = uuidAndString()
        
        XCTAssertEqual(params.uuid, adapter.read?(dummyStorage, dummyKey, params.str))
    }
    
    func testUUIDStrWrite() {
        let adapter = SSKeyFieldConverter.uuidStringAdapter()
        let params = uuidAndString()
        
        XCTAssertEqual(params.str, adapter.write?(&dummyStorage, dummyKey, params.uuid) as? String)
        XCTAssert(dict.isEmpty)
    }
    
    private func uuidAndString() -> (uuid: UUID, str: String) {
        let uuid = UUID()
        let str = uuid.uuidString
        
        return (uuid, str)
    }
}
