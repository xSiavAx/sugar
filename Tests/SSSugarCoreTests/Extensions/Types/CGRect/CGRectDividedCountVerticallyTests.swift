/*
 Tests for divided(count:vertically:) in CGRect extension
 
 [count] variations for the count value (passed as an argument to method)
    = 1
    > 1
 [vertically] variations for the vertically property (passed as an argument to method)
    true
    false
 [origin] variations for the origin point of the rect to which is method applies
    x > 0 && y > 0
    x = 0 && y > 0
    x < 0 && y > 0
    x > 0 && y = 0
    x = 0 && y = 0
    x < 0 && y = 0
    x > 0 && y < 0
    x = 0 && y < 0
    x < 0 && y < 0
 [size] variations for the size of the rect to which is method applies
    width > 0 && height > 0
    width = 0 && height > 0
    width < 0 && height > 0
    width > 0 && height = 0
    width = 0 && height = 0
    width < 0 && height = 0
    width > 0 && height < 0
    width = 0 && height < 0
    width < 0 && height < 0
 
 [Done] test for count with variations count * vertically * origin * size
 [Done] test for size with variations count * vertically * origin * size
 [Done] test for point with variations count * vertically * origin * size
 */

import XCTest
@testable import SSSugarCore

class CGRectDividedCountVerticallyTests: XCTestCase {
    var testDataArray = allTestData
    
    override func tearDown() {
        testDataArray = []
    }
    
    func testCount() {
        testDataArray.forEach { testData in
            let sut = testData.sut
            let count = testData.parameters.count
            let vertically = testData.parameters.vertically
            
            XCTAssertEqual(sut.divided(count: count, vertically: vertically).count, count)
        }
    }
    
    func testSize() {
        testDataArray.forEach { testData in
            let sut = testData.sut
            let count = testData.parameters.count
            let vertically = testData.parameters.vertically
            let expectedResult = testData.expectedSize
            let results = sut.divided(count: count, vertically: vertically)
            
            for result in results {
                XCTAssertEqual(result.size, expectedResult)
            }
        }
    }
    
    func testPoint() {
        testDataArray.forEach { testData in
            let sut = testData.sut
            let count = testData.parameters.count
            let vertically = testData.parameters.vertically
            let expectedResults = testData.expectedOrigins
            let results = sut.divided(count: count, vertically: vertically)
            
            for index in results.indices {
                XCTAssertEqual(results[index].origin, expectedResults[index])
            }
        }
    }
}

// MARK: - Test Data

extension CGRectDividedCountVerticallyTests {
    struct TestData {
        let sut: CGRect
        let parameters: Parameters
        let expectedSize: CGSize
        let expectedOrigins: [CGPoint]
        
        init(sut: CGRect, parameters: Parameters, expectedSize: CGSize, expectedOrigins: [CGPoint]) {
            self.sut = sut
            self.parameters = parameters
            self.expectedSize = expectedSize
            self.expectedOrigins = expectedOrigins
        }
        
        func testDataWithCountOne() -> TestData {
            let sut = self.sut
            let parameters = Parameters(vertically: self.parameters.vertically, count: 1)
            let expectedSize = self.sut.standardized.size
            let expectedOrigins = [self.sut.standardized.origin]
            
            return TestData(sut: sut, parameters: parameters, expectedSize: expectedSize, expectedOrigins: expectedOrigins)
        }
    }
    
    struct Parameters {
        let vertically: Bool
        let count: Int
    }
    
    static let verticallyTestData = [
        TestData(
            sut: CGRect(origin: CGPoint(x: 1, y: 3), size: CGSize(width: 3, height: 4)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 3, height: 2),
            expectedOrigins: [
                CGPoint(x: 1, y: 3),
                CGPoint(x: 1, y: 5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 5), size: CGSize(width: 5, height: 6)),
            parameters: Parameters(vertically: true, count: 6),
            expectedSize: CGSize(width: 5, height: 1),
            expectedOrigins: [
                CGPoint(x: 0, y: 5),
                CGPoint(x: 0, y: 6),
                CGPoint(x: 0, y: 7),
                CGPoint(x: 0, y: 8),
                CGPoint(x: 0, y: 9),
                CGPoint(x: 0, y: 10)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -4, y: 2), size: CGSize(width: 9, height: 9)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 9, height: 3),
            expectedOrigins: [
                CGPoint(x: -4, y: 2),
                CGPoint(x: -4, y: 5),
                CGPoint(x: -4, y: 8)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 4, y: 0), size: CGSize(width: 6, height: 3)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 6, height: 1),
            expectedOrigins: [
                CGPoint(x: 4, y: 0),
                CGPoint(x: 4, y: 1),
                CGPoint(x: 4, y: 2)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 4, height: 6)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 4, height: 3),
            expectedOrigins: [
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 3)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -4, y: 0), size: CGSize(width: 5, height: 5)),
            parameters: Parameters(vertically: true, count: 5),
            expectedSize: CGSize(width: 5, height: 1),
            expectedOrigins: [
                CGPoint(x: -4, y: 0),
                CGPoint(x: -4, y: 1),
                CGPoint(x: -4, y: 2),
                CGPoint(x: -4, y: 3),
                CGPoint(x: -4, y: 4)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 6, y: -8), size: CGSize(width: 9, height: 12)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 9, height: 4),
            expectedOrigins: [
                CGPoint(x: 6, y: -8),
                CGPoint(x: 6, y: -4),
                CGPoint(x: 6, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: -9), size: CGSize(width: 6, height: 4)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 6, height: 2),
            expectedOrigins: [
                CGPoint(x: 0, y: -9),
                CGPoint(x: 0, y: -7)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -4, y: -2), size: CGSize(width: 8, height: 4)),
            parameters: Parameters(vertically: true, count: 4),
            expectedSize: CGSize(width: 8, height: 1),
            expectedOrigins: [
                CGPoint(x: -4, y: -2),
                CGPoint(x: -4, y: -1),
                CGPoint(x: -4, y: 0),
                CGPoint(x: -4, y: 1)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 5, y: 7), size: CGSize(width: 0, height: 6)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 0, height: 2),
            expectedOrigins: [
                CGPoint(x: 5, y: 7),
                CGPoint(x: 5, y: 9),
                CGPoint(x: 5, y: 11)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 6), size: CGSize(width: 0, height: 5)),
            parameters: Parameters(vertically: true, count: 5),
            expectedSize: CGSize(width: 0, height: 1),
            expectedOrigins: [
                CGPoint(x: 0, y: 6),
                CGPoint(x: 0, y: 7),
                CGPoint(x: 0, y: 8),
                CGPoint(x: 0, y: 9),
                CGPoint(x: 0, y: 10)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -5, y: 1), size: CGSize(width: 0, height: 8)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 0, height: 4),
            expectedOrigins: [
                CGPoint(x: -5, y: 1),
                CGPoint(x: -5, y: 5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 1, y: 0), size: CGSize(width: 0, height: 3)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 0, height: 1.5),
            expectedOrigins: [
                CGPoint(x: 1, y: 0),
                CGPoint(x: 1, y: 1.5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 5)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 0, height: 2.5),
            expectedOrigins: [
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 2.5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -9, y: 0), size: CGSize(width: 0, height: 9)),
            parameters: Parameters(vertically: true, count: 4),
            expectedSize: CGSize(width: 0, height: 2.25),
            expectedOrigins: [
                CGPoint(x: -9, y: 0),
                CGPoint(x: -9, y: 2.25),
                CGPoint(x: -9, y: 4.5),
                CGPoint(x: -9, y: 6.75)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 34, y: -7), size: CGSize(width: 0, height: 4)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 0, height: 2),
            expectedOrigins: [
                CGPoint(x: 34, y: -7),
                CGPoint(x: 34, y: -5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: -5), size: CGSize(width: 0, height: 6)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 0, height: 2),
            expectedOrigins: [
                CGPoint(x: 0, y: -5),
                CGPoint(x: 0, y: -3),
                CGPoint(x: 0, y: -1)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -6, y: -3), size: CGSize(width: 0, height: 6)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 0, height: 2),
            expectedOrigins: [
                CGPoint(x: -6, y: -3),
                CGPoint(x: -6, y: -1),
                CGPoint(x: -6, y: 1)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 5, y: 9), size: CGSize(width: -9, height: 8)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 9, height: 4),
            expectedOrigins: [
                CGPoint(x: -4, y: 9),
                CGPoint(x: -4, y: 13)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 5), size: CGSize(width: -5, height: 7)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 5, height: 3.5),
            expectedOrigins: [
                CGPoint(x: -5, y: 5),
                CGPoint(x: -5, y: 8.5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -1, y: 1), size: CGSize(width: -2, height: 3)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 2, height: 1),
            expectedOrigins: [
                CGPoint(x: -3, y: 1),
                CGPoint(x: -3, y: 2),
                CGPoint(x: -3, y: 3)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 8, y: 0), size: CGSize(width: -3, height: 5)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 3, height: 2.5),
            expectedOrigins: [
                CGPoint(x: 5, y: 0),
                CGPoint(x: 5, y: 2.5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: -4, height: 6)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 4, height: 2),
            expectedOrigins: [
                CGPoint(x: -4, y: 0),
                CGPoint(x: -4, y: 2),
                CGPoint(x: -4, y: 4)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -5, y: 0), size: CGSize(width: -6, height: 8)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 6, height: 4),
            expectedOrigins: [
                CGPoint(x: -11, y: 0),
                CGPoint(x: -11, y: 4)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 4, y: -3), size: CGSize(width: -1, height: 10)),
            parameters: Parameters(vertically: true, count: 4),
            expectedSize: CGSize(width: 1, height: 2.5),
            expectedOrigins: [
                CGPoint(x: 3, y: -3),
                CGPoint(x: 3, y: -0.5),
                CGPoint(x: 3, y: 2),
                CGPoint(x: 3, y: 4.5),
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: -9), size: CGSize(width: -5, height: 8)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 5, height: 4),
            expectedOrigins: [
                CGPoint(x: -5, y: -9),
                CGPoint(x: -5, y: -5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -3, y: -5), size: CGSize(width: -6, height: 4)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 6, height: 2),
            expectedOrigins: [
                CGPoint(x: -9, y: -5),
                CGPoint(x: -9, y: -3)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 3, y: 3), size: CGSize(width: 4, height: 0)),
            parameters: Parameters(vertically: true, count: 9),
            expectedSize: CGSize(width: 4, height: 0),
            expectedOrigins: [
                CGPoint(x: 3, y: 3),
                CGPoint(x: 3, y: 3),
                CGPoint(x: 3, y: 3),
                CGPoint(x: 3, y: 3),
                CGPoint(x: 3, y: 3),
                CGPoint(x: 3, y: 3),
                CGPoint(x: 3, y: 3),
                CGPoint(x: 3, y: 3),
                CGPoint(x: 3, y: 3),
                CGPoint(x: 3, y: 3)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 4), size: CGSize(width: 13, height: 0)),
            parameters: Parameters(vertically: true, count: 6),
            expectedSize: CGSize(width: 13, height: 0),
            expectedOrigins: [
                CGPoint(x: 0, y: 4),
                CGPoint(x: 0, y: 4),
                CGPoint(x: 0, y: 4),
                CGPoint(x: 0, y: 4),
                CGPoint(x: 0, y: 4),
                CGPoint(x: 0, y: 4)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -5, y: 4), size: CGSize(width: 4, height: 0)),
            parameters: Parameters(vertically: true, count: 7),
            expectedSize: CGSize(width: 4, height: 0),
            expectedOrigins: [
                CGPoint(x: -5, y: 4),
                CGPoint(x: -5, y: 4),
                CGPoint(x: -5, y: 4),
                CGPoint(x: -5, y: 4),
                CGPoint(x: -5, y: 4),
                CGPoint(x: -5, y: 4),
                CGPoint(x: -5, y: 4)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 6, y: 0), size: CGSize(width: 5, height: 0)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 5, height: 0),
            expectedOrigins: [
                CGPoint(x: 6, y: 0),
                CGPoint(x: 6, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 6, height: 0)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 6, height: 0),
            expectedOrigins: [
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -4, y: 0), size: CGSize(width: 8, height: 0)),
            parameters: Parameters(vertically: true, count: 4),
            expectedSize: CGSize(width: 8, height: 0),
            expectedOrigins: [
                CGPoint(x: -4, y: 0),
                CGPoint(x: -4, y: 0),
                CGPoint(x: -4, y: 0),
                CGPoint(x: -4, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 4, y: -5), size: CGSize(width: 3, height: 0)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 3, height: 0),
            expectedOrigins: [
                CGPoint(x: 4, y: -5),
                CGPoint(x: 4, y: -5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: -4), size: CGSize(width: 4, height: 0)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 4, height: 0),
            expectedOrigins: [
                CGPoint(x: 0, y: -4),
                CGPoint(x: 0, y: -4),
                CGPoint(x: 0, y: -4)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -2, y: -6), size: CGSize(width: 5, height: 0)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 5, height: 0),
            expectedOrigins: [
                CGPoint(x: -2, y: -6),
                CGPoint(x: -2, y: -6)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 4, y: 2), size: CGSize(width: 0, height: 0)),
            parameters: Parameters(vertically: true, count: 5),
            expectedSize: CGSize(width: 0, height: 0),
            expectedOrigins: [
                CGPoint(x: 4, y: 2),
                CGPoint(x: 4, y: 2),
                CGPoint(x: 4, y: 2),
                CGPoint(x: 4, y: 2),
                CGPoint(x: 4, y: 2)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 4), size: CGSize(width: 0, height: 0)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 0, height: 0),
            expectedOrigins: [
                CGPoint(x: 0, y: 4),
                CGPoint(x: 0, y: 4),
                CGPoint(x: 0, y: 4)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -5, y: 9), size: CGSize(width: 0, height: 0)),
            parameters: Parameters(vertically: true, count: 4),
            expectedSize: CGSize(width: 0, height: 0),
            expectedOrigins: [
                CGPoint(x: -5, y: 9),
                CGPoint(x: -5, y: 9),
                CGPoint(x: -5, y: 9),
                CGPoint(x: -5, y: 9)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 8, y: 0), size: CGSize(width: 0, height: 0)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 0, height: 0),
            expectedOrigins: [
                CGPoint(x: 8, y: 0),
                CGPoint(x: 8, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0)),
            parameters: Parameters(vertically: true, count: 5),
            expectedSize: CGSize(width: 0, height: 0),
            expectedOrigins: [
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -6, y: 0), size: CGSize(width: 0, height: 0)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 0, height: 0),
            expectedOrigins: [
                CGPoint(x: -6, y: 0),
                CGPoint(x: -6, y: 0),
                CGPoint(x: -6, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 1, y: -1), size: CGSize(width: 0, height: 0)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 0, height: 0),
            expectedOrigins: [
                CGPoint(x: 1, y: -1),
                CGPoint(x: 1, y: -1)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: -4), size: CGSize(width: 0, height: 0)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 0, height: 0),
            expectedOrigins: [
                CGPoint(x: 0, y: -4),
                CGPoint(x: 0, y: -4),
                CGPoint(x: 0, y: -4)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -4, y: -7), size: CGSize(width: 0, height: 0)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 0, height: 0),
            expectedOrigins: [
                CGPoint(x: -4, y: -7),
                CGPoint(x: -4, y: -7),
                CGPoint(x: -4, y: -7)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 8, y: 1), size: CGSize(width: -4, height: 0)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 4, height: 0),
            expectedOrigins: [
                CGPoint(x: 4, y: 1),
                CGPoint(x: 4, y: 1),
                CGPoint(x: 4, y: 1)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 7), size: CGSize(width: -5, height: 0)),
            parameters: Parameters(vertically: true, count: 4),
            expectedSize: CGSize(width: 5, height: 0),
            expectedOrigins: [
                CGPoint(x: -5, y: 7),
                CGPoint(x: -5, y: 7),
                CGPoint(x: -5, y: 7),
                CGPoint(x: -5, y: 7)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -2, y: 1), size: CGSize(width: -9, height: 0)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 9, height: 0),
            expectedOrigins: [
                CGPoint(x: -11, y: 1),
                CGPoint(x: -11, y: 1)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 6, y: 0), size: CGSize(width: -1, height: 0)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 1, height: 0),
            expectedOrigins: [
                CGPoint(x: 5, y: 0),
                CGPoint(x: 5, y: 0),
                CGPoint(x: 5, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: -18, height: 0)),
            parameters: Parameters(vertically: true, count: 8),
            expectedSize: CGSize(width: 18, height: 0),
            expectedOrigins: [
                CGPoint(x: -18, y: 0),
                CGPoint(x: -18, y: 0),
                CGPoint(x: -18, y: 0),
                CGPoint(x: -18, y: 0),
                CGPoint(x: -18, y: 0),
                CGPoint(x: -18, y: 0),
                CGPoint(x: -18, y: 0),
                CGPoint(x: -18, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -8, y: 0), size: CGSize(width: -8, height: 0)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 8, height: 0),
            expectedOrigins: [
                CGPoint(x: -16, y: 0),
                CGPoint(x: -16, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 6, y: -3), size: CGSize(width: -2, height: 0)),
            parameters: Parameters(vertically: true, count: 7),
            expectedSize: CGSize(width: 2, height: 0),
            expectedOrigins: [
                CGPoint(x: 4, y: -3),
                CGPoint(x: 4, y: -3),
                CGPoint(x: 4, y: -3),
                CGPoint(x: 4, y: -3),
                CGPoint(x: 4, y: -3),
                CGPoint(x: 4, y: -3),
                CGPoint(x: 4, y: -3)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: -3), size: CGSize(width: -3, height: 0)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 3, height: 0),
            expectedOrigins: [
                CGPoint(x: -3, y: -3),
                CGPoint(x: -3, y: -3),
                CGPoint(x: -3, y: -3)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -5, y: -5), size: CGSize(width: -7, height: 0)),
            parameters: Parameters(vertically: true, count: 6),
            expectedSize: CGSize(width: 7, height: 0),
            expectedOrigins: [
                CGPoint(x: -12, y: -5),
                CGPoint(x: -12, y: -5),
                CGPoint(x: -12, y: -5),
                CGPoint(x: -12, y: -5),
                CGPoint(x: -12, y: -5),
                CGPoint(x: -12, y: -5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 6, y: 3), size: CGSize(width: 3, height: -5)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 3, height: 2.5),
            expectedOrigins: [
                CGPoint(x: 6, y: -2),
                CGPoint(x: 6, y: 0.5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 8), size: CGSize(width: 7, height: -1)),
            parameters: Parameters(vertically: true, count: 4),
            expectedSize: CGSize(width: 7, height: 0.25),
            expectedOrigins: [
                CGPoint(x: 0, y: 7),
                CGPoint(x: 0, y: 7.25),
                CGPoint(x: 0, y: 7.5),
                CGPoint(x: 0, y: 7.75)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -3, y: 3), size: CGSize(width: 4, height: -8)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 4, height: 4),
            expectedOrigins: [
                CGPoint(x: -3, y: -5),
                CGPoint(x: -3, y: -1)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 9, y: 0), size: CGSize(width: 9, height: -5)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 9, height: 2.5),
            expectedOrigins: [
                CGPoint(x: 9, y: -5),
                CGPoint(x: 9, y: -2.5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 8, height: -3)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 8, height: 1),
            expectedOrigins: [
                CGPoint(x: 0, y: -3),
                CGPoint(x: 0, y: -2),
                CGPoint(x: 0, y: -1)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -7, y: 0), size: CGSize(width: 3, height: -4)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 3, height: 2),
            expectedOrigins: [
                CGPoint(x: -7, y: -4),
                CGPoint(x: -7, y: -2)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 6, y: -1), size: CGSize(width: 6, height: -6)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 6, height: 2),
            expectedOrigins: [
                CGPoint(x: 6, y: -7),
                CGPoint(x: 6, y: -5),
                CGPoint(x: 6, y: -3)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: -4), size: CGSize(width: 12, height: -8)),
            parameters: Parameters(vertically: true, count: 4),
            expectedSize: CGSize(width: 12, height: 2),
            expectedOrigins: [
                CGPoint(x: 0, y: -12),
                CGPoint(x: 0, y: -10),
                CGPoint(x: 0, y: -8),
                CGPoint(x: 0, y: -6)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -4, y: -2), size: CGSize(width: 8, height: -4)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 8, height: 2),
            expectedOrigins: [
                CGPoint(x: -4, y: -6),
                CGPoint(x: -4, y: -4)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 10, y: 2), size: CGSize(width: 0, height: -2)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 0, height: 1),
            expectedOrigins: [
                CGPoint(x: 10, y: 0),
                CGPoint(x: 10, y: 1)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 6), size: CGSize(width: 0, height: -9)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 0, height: 3),
            expectedOrigins: [
                CGPoint(x: 0, y: -3),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 3)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -8, y: 8), size: CGSize(width: 0, height: -6)),
            parameters: Parameters(vertically: true, count: 4),
            expectedSize: CGSize(width: 0, height: 1.5),
            expectedOrigins: [
                CGPoint(x: -8, y: 2),
                CGPoint(x: -8, y: 3.5),
                CGPoint(x: -8, y: 5),
                CGPoint(x: -8, y: 6.5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 4, y: 0), size: CGSize(width: 0, height: -3)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 0, height: 1.5),
            expectedOrigins: [
                CGPoint(x: 4, y: -3),
                CGPoint(x: 4, y: -1.5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: -4)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 0, height: 2),
            expectedOrigins: [
                CGPoint(x: 0, y: -4),
                CGPoint(x: 0, y: -2)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -2, y: 0), size: CGSize(width: 0, height: -9)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 0, height: 3),
            expectedOrigins: [
                CGPoint(x: -2, y: -9),
                CGPoint(x: -2, y: -6),
                CGPoint(x: -2, y: -3)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 5, y: -8), size: CGSize(width: 0, height: -14)),
            parameters: Parameters(vertically: true, count: 7),
            expectedSize: CGSize(width: 0, height: 2),
            expectedOrigins: [
                CGPoint(x: 5, y: -22),
                CGPoint(x: 5, y: -20),
                CGPoint(x: 5, y: -18),
                CGPoint(x: 5, y: -16),
                CGPoint(x: 5, y: -14),
                CGPoint(x: 5, y: -12),
                CGPoint(x: 5, y: -10)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: -13), size: CGSize(width: 0, height: -5)),
            parameters: Parameters(vertically: true, count: 5),
            expectedSize: CGSize(width: 0, height: 1),
            expectedOrigins: [
                CGPoint(x: 0, y: -18),
                CGPoint(x: 0, y: -17),
                CGPoint(x: 0, y: -16),
                CGPoint(x: 0, y: -15),
                CGPoint(x: 0, y: -14)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -3, y: -9), size: CGSize(width: 0, height: -6)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 0, height: 3),
            expectedOrigins: [
                CGPoint(x: -3, y: -15),
                CGPoint(x: -3, y: -12)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 7, y: 7), size: CGSize(width: -4, height: -4)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 4, height: 2),
            expectedOrigins: [
                CGPoint(x: 3, y: 3),
                CGPoint(x: 3, y: 5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 5), size: CGSize(width: -8, height: -12)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 8, height: 4),
            expectedOrigins: [
                CGPoint(x: -8, y: -7),
                CGPoint(x: -8, y: -3),
                CGPoint(x: -8, y: 1)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -4, y: 9), size: CGSize(width: -5, height: -8)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 5, height: 4),
            expectedOrigins: [
                CGPoint(x: -9, y: 1),
                CGPoint(x: -9, y: 5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 5, y: 0), size: CGSize(width: -1, height: -1)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 1, height: 0.5),
            expectedOrigins: [
                CGPoint(x: 4, y: -1),
                CGPoint(x: 4, y: -0.5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: -7, height: -27)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 7, height: 9),
            expectedOrigins: [
                CGPoint(x: -7, y: -27),
                CGPoint(x: -7, y: -18),
                CGPoint(x: -7, y: -9)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -10, y: 0), size: CGSize(width: -7, height: -3)),
            parameters: Parameters(vertically: true, count: 3),
            expectedSize: CGSize(width: 7, height: 1),
            expectedOrigins: [
                CGPoint(x: -17, y: -3),
                CGPoint(x: -17, y: -2),
                CGPoint(x: -17, y: -1)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 9, y: -13), size: CGSize(width: -8, height: -7)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 8, height: 3.5),
            expectedOrigins: [
                CGPoint(x: 1, y: -20),
                CGPoint(x: 1, y: -16.5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: -2), size: CGSize(width: -5, height: -2)),
            parameters: Parameters(vertically: true, count: 2),
            expectedSize: CGSize(width: 5, height: 1),
            expectedOrigins: [
                CGPoint(x: -5, y: -4),
                CGPoint(x: -5, y: -3)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -3, y: -8), size: CGSize(width: -6, height: -1)),
            parameters: Parameters(vertically: true, count: 4),
            expectedSize: CGSize(width: 6, height: 0.25),
            expectedOrigins: [
                CGPoint(x: -9, y: -9),
                CGPoint(x: -9, y: -8.75),
                CGPoint(x: -9, y: -8.5),
                CGPoint(x: -9, y: -8.25)
            ]
        ),
    ]
    static let horizontallyTestData = [
        TestData(
            sut: CGRect(origin: CGPoint(x: 1, y: 3), size: CGSize(width: 3, height: 4)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 1.5, height: 4),
            expectedOrigins: [
                CGPoint(x: 1, y: 3),
                CGPoint(x: 2.5, y: 3)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 5), size: CGSize(width: 7, height: 6)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 3.5, height: 6),
            expectedOrigins: [
                CGPoint(x: 0, y: 5),
                CGPoint(x: 3.5, y: 5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -4, y: 2), size: CGSize(width: 9, height: 9)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 3, height: 9),
            expectedOrigins: [
                CGPoint(x: -4, y: 2),
                CGPoint(x: -1, y: 2),
                CGPoint(x: 2, y: 2)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 4, y: 0), size: CGSize(width: 6, height: 3)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 2, height: 3),
            expectedOrigins: [
                CGPoint(x: 4, y: 0),
                CGPoint(x: 6, y: 0),
                CGPoint(x: 8, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 4, height: 6)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 2, height: 6),
            expectedOrigins: [
                CGPoint(x: 0, y: 0),
                CGPoint(x: 2, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -4, y: 0), size: CGSize(width: 5, height: 5)),
            parameters: Parameters(vertically: false, count: 5),
            expectedSize: CGSize(width: 1, height: 5),
            expectedOrigins: [
                CGPoint(x: -4, y: 0),
                CGPoint(x: -3, y: 0),
                CGPoint(x: -2, y: 0),
                CGPoint(x: -1, y: 0),
                CGPoint(x: 0, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 6, y: -8), size: CGSize(width: 9, height: 12)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 3, height: 12),
            expectedOrigins: [
                CGPoint(x: 6, y: -8),
                CGPoint(x: 9, y: -8),
                CGPoint(x: 12, y: -8)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: -9), size: CGSize(width: 6, height: 4)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 3, height: 4),
            expectedOrigins: [
                CGPoint(x: 0, y: -9),
                CGPoint(x: 3, y: -9)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -4, y: -2), size: CGSize(width: 8, height: 4)),
            parameters: Parameters(vertically: false, count: 4),
            expectedSize: CGSize(width: 2, height: 4),
            expectedOrigins: [
                CGPoint(x: -4, y: -2),
                CGPoint(x: -2, y: -2),
                CGPoint(x: 0, y: -2),
                CGPoint(x: 2, y: -2)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 5, y: 7), size: CGSize(width: 0, height: 6)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 0, height: 6),
            expectedOrigins: [
                CGPoint(x: 5, y: 7),
                CGPoint(x: 5, y: 7),
                CGPoint(x: 5, y: 7)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 6), size: CGSize(width: 0, height: 5)),
            parameters: Parameters(vertically: false, count: 5),
            expectedSize: CGSize(width: 0, height: 5),
            expectedOrigins: [
                CGPoint(x: 0, y: 6),
                CGPoint(x: 0, y: 6),
                CGPoint(x: 0, y: 6),
                CGPoint(x: 0, y: 6),
                CGPoint(x: 0, y: 6)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -5, y: 1), size: CGSize(width: 0, height: 8)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 0, height: 8),
            expectedOrigins: [
                CGPoint(x: -5, y: 1),
                CGPoint(x: -5, y: 1)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 1, y: 0), size: CGSize(width: 0, height: 3)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 0, height: 3),
            expectedOrigins: [
                CGPoint(x: 1, y: 0),
                CGPoint(x: 1, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 5)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 0, height: 5),
            expectedOrigins: [
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -9, y: 0), size: CGSize(width: 0, height: 9)),
            parameters: Parameters(vertically: false, count: 4),
            expectedSize: CGSize(width: 0, height: 9),
            expectedOrigins: [
                CGPoint(x: -9, y: 0),
                CGPoint(x: -9, y: 0),
                CGPoint(x: -9, y: 0),
                CGPoint(x: -9, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 34, y: -7), size: CGSize(width: 0, height: 4)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 0, height: 4),
            expectedOrigins: [
                CGPoint(x: 34, y: -7),
                CGPoint(x: 34, y: -7)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: -5), size: CGSize(width: 0, height: 6)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 0, height: 6),
            expectedOrigins: [
                CGPoint(x: 0, y: -5),
                CGPoint(x: 0, y: -5),
                CGPoint(x: 0, y: -5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -6, y: -3), size: CGSize(width: 0, height: 6)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 0, height: 6),
            expectedOrigins: [
                CGPoint(x: -6, y: -3),
                CGPoint(x: -6, y: -3),
                CGPoint(x: -6, y: -3)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 5, y: 9), size: CGSize(width: -9, height: 8)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 4.5, height: 8),
            expectedOrigins: [
                CGPoint(x: -4, y: 9),
                CGPoint(x: 0.5, y: 9)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 5), size: CGSize(width: -5, height: 7)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 2.5, height: 7),
            expectedOrigins: [
                CGPoint(x: -5, y: 5),
                CGPoint(x: -2.5, y: 5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -1, y: 1), size: CGSize(width: -2, height: 3)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 1, height: 3),
            expectedOrigins: [
                CGPoint(x: -3, y: 1),
                CGPoint(x: -2, y: 1)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 8, y: 0), size: CGSize(width: -3, height: 5)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 1.5, height: 5),
            expectedOrigins: [
                CGPoint(x: 5, y: 0),
                CGPoint(x: 6.5, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: -3, height: 6)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 1, height: 6),
            expectedOrigins: [
                CGPoint(x: -3, y: 0),
                CGPoint(x: -2, y: 0),
                CGPoint(x: -1, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -5, y: 0), size: CGSize(width: -6, height: 8)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 3, height: 8),
            expectedOrigins: [
                CGPoint(x: -11, y: 0),
                CGPoint(x: -8, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 4, y: -3), size: CGSize(width: -1, height: 10)),
            parameters: Parameters(vertically: false, count: 4),
            expectedSize: CGSize(width: 0.25, height: 10),
            expectedOrigins: [
                CGPoint(x: 3, y: -3),
                CGPoint(x: 3.25, y: -3),
                CGPoint(x: 3.5, y: -3),
                CGPoint(x: 3.75, y: -3),
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: -9), size: CGSize(width: -5, height: 8)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 2.5, height: 8),
            expectedOrigins: [
                CGPoint(x: -5, y: -9),
                CGPoint(x: -2.5, y: -9)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -3, y: -5), size: CGSize(width: -6, height: 4)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 3, height: 4),
            expectedOrigins: [
                CGPoint(x: -9, y: -5),
                CGPoint(x: -6, y: -5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 3, y: 3), size: CGSize(width: 4, height: 0)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 2, height: 0),
            expectedOrigins: [
                CGPoint(x: 3, y: 3),
                CGPoint(x: 5, y: 3)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 4), size: CGSize(width: 12, height: 0)),
            parameters: Parameters(vertically: false, count: 6),
            expectedSize: CGSize(width: 2, height: 0),
            expectedOrigins: [
                CGPoint(x: 0, y: 4),
                CGPoint(x: 2, y: 4),
                CGPoint(x: 4, y: 4),
                CGPoint(x: 6, y: 4),
                CGPoint(x: 8, y: 4),
                CGPoint(x: 10, y: 4)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -5, y: 4), size: CGSize(width: 7, height: 0)),
            parameters: Parameters(vertically: false, count: 7),
            expectedSize: CGSize(width: 1, height: 0),
            expectedOrigins: [
                CGPoint(x: -5, y: 4),
                CGPoint(x: -4, y: 4),
                CGPoint(x: -3, y: 4),
                CGPoint(x: -2, y: 4),
                CGPoint(x: -1, y: 4),
                CGPoint(x: 0, y: 4),
                CGPoint(x: 1, y: 4)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 6, y: 0), size: CGSize(width: 5, height: 0)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 2.5, height: 0),
            expectedOrigins: [
                CGPoint(x: 6, y: 0),
                CGPoint(x: 8.5, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 6, height: 0)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 2, height: 0),
            expectedOrigins: [
                CGPoint(x: 0, y: 0),
                CGPoint(x: 2, y: 0),
                CGPoint(x: 4, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -4, y: 0), size: CGSize(width: 8, height: 0)),
            parameters: Parameters(vertically: false, count: 4),
            expectedSize: CGSize(width: 2, height: 0),
            expectedOrigins: [
                CGPoint(x: -4, y: 0),
                CGPoint(x: -2, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 2, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 4, y: -5), size: CGSize(width: 3, height: 0)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 1.5, height: 0),
            expectedOrigins: [
                CGPoint(x: 4, y: -5),
                CGPoint(x: 5.5, y: -5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: -4), size: CGSize(width: 6, height: 0)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 2, height: 0),
            expectedOrigins: [
                CGPoint(x: 0, y: -4),
                CGPoint(x: 2, y: -4),
                CGPoint(x: 4, y: -4)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -2, y: -6), size: CGSize(width: 5, height: 0)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 2.5, height: 0),
            expectedOrigins: [
                CGPoint(x: -2, y: -6),
                CGPoint(x: 0.5, y: -6)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 4, y: 2), size: CGSize(width: 0, height: 0)),
            parameters: Parameters(vertically: false, count: 5),
            expectedSize: CGSize(width: 0, height: 0),
            expectedOrigins: [
                CGPoint(x: 4, y: 2),
                CGPoint(x: 4, y: 2),
                CGPoint(x: 4, y: 2),
                CGPoint(x: 4, y: 2),
                CGPoint(x: 4, y: 2)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 4), size: CGSize(width: 0, height: 0)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 0, height: 0),
            expectedOrigins: [
                CGPoint(x: 0, y: 4),
                CGPoint(x: 0, y: 4),
                CGPoint(x: 0, y: 4)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -5, y: 9), size: CGSize(width: 0, height: 0)),
            parameters: Parameters(vertically: false, count: 4),
            expectedSize: CGSize(width: 0, height: 0),
            expectedOrigins: [
                CGPoint(x: -5, y: 9),
                CGPoint(x: -5, y: 9),
                CGPoint(x: -5, y: 9),
                CGPoint(x: -5, y: 9)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 8, y: 0), size: CGSize(width: 0, height: 0)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 0, height: 0),
            expectedOrigins: [
                CGPoint(x: 8, y: 0),
                CGPoint(x: 8, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0)),
            parameters: Parameters(vertically: false, count: 5),
            expectedSize: CGSize(width: 0, height: 0),
            expectedOrigins: [
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -6, y: 0), size: CGSize(width: 0, height: 0)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 0, height: 0),
            expectedOrigins: [
                CGPoint(x: -6, y: 0),
                CGPoint(x: -6, y: 0),
                CGPoint(x: -6, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 1, y: -1), size: CGSize(width: 0, height: 0)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 0, height: 0),
            expectedOrigins: [
                CGPoint(x: 1, y: -1),
                CGPoint(x: 1, y: -1)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: -4), size: CGSize(width: 0, height: 0)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 0, height: 0),
            expectedOrigins: [
                CGPoint(x: 0, y: -4),
                CGPoint(x: 0, y: -4),
                CGPoint(x: 0, y: -4)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -4, y: -7), size: CGSize(width: 0, height: 0)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 0, height: 0),
            expectedOrigins: [
                CGPoint(x: -4, y: -7),
                CGPoint(x: -4, y: -7),
                CGPoint(x: -4, y: -7)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 8, y: 1), size: CGSize(width: -4, height: 0)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 2, height: 0),
            expectedOrigins: [
                CGPoint(x: 4, y: 1),
                CGPoint(x: 6, y: 1)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 7), size: CGSize(width: -6, height: 0)),
            parameters: Parameters(vertically: false, count: 4),
            expectedSize: CGSize(width: 1.5, height: 0),
            expectedOrigins: [
                CGPoint(x: -6, y: 7),
                CGPoint(x: -4.5, y: 7),
                CGPoint(x: -3, y: 7),
                CGPoint(x: -1.5, y: 7)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -2, y: 1), size: CGSize(width: -9, height: 0)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 4.5, height: 0),
            expectedOrigins: [
                CGPoint(x: -11, y: 1),
                CGPoint(x: -6.5, y: 1)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 6, y: 0), size: CGSize(width: -1, height: 0)),
            parameters: Parameters(vertically: false, count: 4),
            expectedSize: CGSize(width: 0.25, height: 0),
            expectedOrigins: [
                CGPoint(x: 5, y: 0),
                CGPoint(x: 5.25, y: 0),
                CGPoint(x: 5.5, y: 0),
                CGPoint(x: 5.75, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: -18, height: 0)),
            parameters: Parameters(vertically: false, count: 6),
            expectedSize: CGSize(width: 3, height: 0),
            expectedOrigins: [
                CGPoint(x: -18, y: 0),
                CGPoint(x: -15, y: 0),
                CGPoint(x: -12, y: 0),
                CGPoint(x: -9, y: 0),
                CGPoint(x: -6, y: 0),
                CGPoint(x: -3, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -8, y: 0), size: CGSize(width: -8, height: 0)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 4, height: 0),
            expectedOrigins: [
                CGPoint(x: -16, y: 0),
                CGPoint(x: -12, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 6, y: -3), size: CGSize(width: -2, height: 0)),
            parameters: Parameters(vertically: false, count: 8),
            expectedSize: CGSize(width: 0.25, height: 0),
            expectedOrigins: [
                CGPoint(x: 4, y: -3),
                CGPoint(x: 4.25, y: -3),
                CGPoint(x: 4.5, y: -3),
                CGPoint(x: 4.75, y: -3),
                CGPoint(x: 5, y: -3),
                CGPoint(x: 5.25, y: -3),
                CGPoint(x: 5.5, y: -3),
                CGPoint(x: 5.75, y: -3)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: -3), size: CGSize(width: -3, height: 0)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 1, height: 0),
            expectedOrigins: [
                CGPoint(x: -3, y: -3),
                CGPoint(x: -2, y: -3),
                CGPoint(x: -1, y: -3)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -5, y: -5), size: CGSize(width: -6, height: 0)),
            parameters: Parameters(vertically: false, count: 6),
            expectedSize: CGSize(width: 1, height: 0),
            expectedOrigins: [
                CGPoint(x: -11, y: -5),
                CGPoint(x: -10, y: -5),
                CGPoint(x: -9, y: -5),
                CGPoint(x: -8, y: -5),
                CGPoint(x: -7, y: -5),
                CGPoint(x: -6, y: -5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 6, y: 3), size: CGSize(width: 3, height: -5)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 1.5, height: 5),
            expectedOrigins: [
                CGPoint(x: 6, y: -2),
                CGPoint(x: 7.5, y: -2)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 8), size: CGSize(width: 6, height: -1)),
            parameters: Parameters(vertically: false, count: 4),
            expectedSize: CGSize(width: 1.5, height: 1),
            expectedOrigins: [
                CGPoint(x: 0, y: 7),
                CGPoint(x: 1.5, y: 7),
                CGPoint(x: 3, y: 7),
                CGPoint(x: 4.5, y: 7)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -3, y: 3), size: CGSize(width: 4, height: -8)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 2, height: 8),
            expectedOrigins: [
                CGPoint(x: -3, y: -5),
                CGPoint(x: -1, y: -5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 9, y: 0), size: CGSize(width: 9, height: -5)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 4.5, height: 5),
            expectedOrigins: [
                CGPoint(x: 9, y: -5),
                CGPoint(x: 13.5, y: -5)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 9, height: -3)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 3, height: 3),
            expectedOrigins: [
                CGPoint(x: 0, y: -3),
                CGPoint(x: 3, y: -3),
                CGPoint(x: 6, y: -3)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -7, y: 0), size: CGSize(width: 3, height: -4)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 1.5, height: 4),
            expectedOrigins: [
                CGPoint(x: -7, y: -4),
                CGPoint(x: -5.5, y: -4)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 6, y: -1), size: CGSize(width: 6, height: -6)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 2, height: 6),
            expectedOrigins: [
                CGPoint(x: 6, y: -7),
                CGPoint(x: 8, y: -7),
                CGPoint(x: 10, y: -7)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: -4), size: CGSize(width: 12, height: -8)),
            parameters: Parameters(vertically: false, count: 4),
            expectedSize: CGSize(width: 3, height: 8),
            expectedOrigins: [
                CGPoint(x: 0, y: -12),
                CGPoint(x: 3, y: -12),
                CGPoint(x: 6, y: -12),
                CGPoint(x: 9, y: -12)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -4, y: -2), size: CGSize(width: 8, height: -4)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 4, height: 4),
            expectedOrigins: [
                CGPoint(x: -4, y: -6),
                CGPoint(x: 0, y: -6)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 10, y: 2), size: CGSize(width: 0, height: -2)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 0, height: 2),
            expectedOrigins: [
                CGPoint(x: 10, y: 0),
                CGPoint(x: 10, y: 0)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 6), size: CGSize(width: 0, height: -9)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 0, height: 9),
            expectedOrigins: [
                CGPoint(x: 0, y: -3),
                CGPoint(x: 0, y: -3),
                CGPoint(x: 0, y: -3)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -8, y: 8), size: CGSize(width: 0, height: -6)),
            parameters: Parameters(vertically: false, count: 4),
            expectedSize: CGSize(width: 0, height: 6),
            expectedOrigins: [
                CGPoint(x: -8, y: 2),
                CGPoint(x: -8, y: 2),
                CGPoint(x: -8, y: 2),
                CGPoint(x: -8, y: 2)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 4, y: 0), size: CGSize(width: 0, height: -3)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 0, height: 3),
            expectedOrigins: [
                CGPoint(x: 4, y: -3),
                CGPoint(x: 4, y: -3)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: -4)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 0, height: 4),
            expectedOrigins: [
                CGPoint(x: 0, y: -4),
                CGPoint(x: 0, y: -4)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -2, y: 0), size: CGSize(width: 0, height: -9)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 0, height: 9),
            expectedOrigins: [
                CGPoint(x: -2, y: -9),
                CGPoint(x: -2, y: -9),
                CGPoint(x: -2, y: -9)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 5, y: -8), size: CGSize(width: 0, height: -14)),
            parameters: Parameters(vertically: false, count: 7),
            expectedSize: CGSize(width: 0, height: 14),
            expectedOrigins: [
                CGPoint(x: 5, y: -22),
                CGPoint(x: 5, y: -22),
                CGPoint(x: 5, y: -22),
                CGPoint(x: 5, y: -22),
                CGPoint(x: 5, y: -22),
                CGPoint(x: 5, y: -22),
                CGPoint(x: 5, y: -22)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: -13), size: CGSize(width: 0, height: -5)),
            parameters: Parameters(vertically: false, count: 5),
            expectedSize: CGSize(width: 0, height: 5),
            expectedOrigins: [
                CGPoint(x: 0, y: -18),
                CGPoint(x: 0, y: -18),
                CGPoint(x: 0, y: -18),
                CGPoint(x: 0, y: -18),
                CGPoint(x: 0, y: -18)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -3, y: -9), size: CGSize(width: 0, height: -6)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 0, height: 6),
            expectedOrigins: [
                CGPoint(x: -3, y: -15),
                CGPoint(x: -3, y: -15)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 7, y: 7), size: CGSize(width: -4, height: -4)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 2, height: 4),
            expectedOrigins: [
                CGPoint(x: 3, y: 3),
                CGPoint(x: 5, y: 3)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 5), size: CGSize(width: -9, height: -12)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 3, height: 12),
            expectedOrigins: [
                CGPoint(x: -9, y: -7),
                CGPoint(x: -6, y: -7),
                CGPoint(x: -3, y: -7)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -4, y: 9), size: CGSize(width: -5, height: -8)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 2.5, height: 8),
            expectedOrigins: [
                CGPoint(x: -9, y: 1),
                CGPoint(x: -6.5, y: 1)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 5, y: 0), size: CGSize(width: -1, height: -1)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 0.5, height: 1),
            expectedOrigins: [
                CGPoint(x: 4, y: -1),
                CGPoint(x: 4.5, y: -1)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: -6, height: -27)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 2, height: 27),
            expectedOrigins: [
                CGPoint(x: -6, y: -27),
                CGPoint(x: -4, y: -27),
                CGPoint(x: -2, y: -27)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -10, y: 0), size: CGSize(width: -9, height: -3)),
            parameters: Parameters(vertically: false, count: 3),
            expectedSize: CGSize(width: 3, height: 3),
            expectedOrigins: [
                CGPoint(x: -19, y: -3),
                CGPoint(x: -16, y: -3),
                CGPoint(x: -13, y: -3)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 9, y: -13), size: CGSize(width: -8, height: -7)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 4, height: 7),
            expectedOrigins: [
                CGPoint(x: 1, y: -20),
                CGPoint(x: 5, y: -20)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: 0, y: -2), size: CGSize(width: -5, height: -2)),
            parameters: Parameters(vertically: false, count: 2),
            expectedSize: CGSize(width: 2.5, height: 2),
            expectedOrigins: [
                CGPoint(x: -5, y: -4),
                CGPoint(x: -2.5, y: -4)
            ]
        ),
        TestData(
            sut: CGRect(origin: CGPoint(x: -4, y: -8), size: CGSize(width: -5, height: -1)),
            parameters: Parameters(vertically: false, count: 4),
            expectedSize: CGSize(width: 1.25, height: 1),
            expectedOrigins: [
                CGPoint(x: -9, y: -9),
                CGPoint(x: -7.75, y: -9),
                CGPoint(x: -6.5, y: -9),
                CGPoint(x: -5.25, y: -9)
            ]
        ),
    ]
    static var verticallyCountOneTestData: [TestData] {
        verticallyTestData.map { $0.testDataWithCountOne() }
    }
    static var horizontallyCountOneTestData: [TestData] {
        horizontallyTestData.map { $0.testDataWithCountOne() }
    }
    static var allTestData: [TestData] {
        verticallyTestData + horizontallyTestData + verticallyCountOneTestData + horizontallyCountOneTestData
    }
}
