import Foundation
import XCTest

@testable import SSSugarCore

/// Test Cases for `DateProvider`
///
/// Will  be tested only `DateBuilding` methods, since `DateProviding` methods obviously can't be tested relably.
///
/// # Cases:
/// * _dateTsBased_ – creates date based on passed ts
/// * _dateIntervalBased_ – creates date based on passed ts
/// * _dateIntervalAndSinceBased_ – creates date based on passed ts and date
class DateProviderTests: XCTestCase {
    var sut: DateProvider!
    
    func testDateTsBased() {
        let tses = [100500, 1, 1637065202, Int.max, 0]
        
        func check(ts: Int) {
            let date = sut.date(ts: ts)
            let expDate = Date(ts: ts)
            
            XCTAssertEqual(date, expDate)
        }
        tses.forEach() { check(ts: $0) }
    }
    
    func testIntervalBased() {
        let tses = [100500.100500, 1.1, 1.0, 1637065202.1248, TimeInterval(Int.max), 0.0]
        
        func check(interval: TimeInterval) {
            let date = sut.date(interval: interval)
            let expDate = Date(timeIntervalSince1970: interval)
            
            XCTAssertEqual(date, expDate)
        }
        tses.forEach() { check(interval: $0) }
    }
    
    func testIntervalAndSinceBased() {
        let tses = [100500.100500, -500, 1.1, 1.0, 1637065202.1248, 0.0, -1.1, -1.0]
        let dates = [Date(), Date(timeIntervalSince1970: 1000), Date(timeInterval: 1000, since: Date())]
        
        func check(interval: TimeInterval, since: Date) {
            let date = sut.date(interval: interval, since: since)
            let expDate = Date(timeInterval: interval, since: since)
            
            XCTAssertEqual(date, expDate)
        }
        tses.forEach() { ts in
            dates.forEach() { date in
                check(interval: ts, since: date)
            }
        }
    }
    
    override func setUp() {
        sut = DateProvider()
    }
    
    override func tearDown() {
        sut = nil
    }
}
