/*
 
 Tests for UIViewController extension kbDidChangeHeightTo()
 
 [Done] keyboard notification
    [Done] did show
    [Done] did hide
 [Done] keyboard rect
    [Done] origin
        [Done] x > 0, y > 0
        [Done] x > 0, y < 0
        [Done] x > 0, y == 0
        [Done] x < 0, y > 0
        [Done] x < 0, y < 0
        [Done] x < 0, y == 0
        [Done] x == 0, y > 0
        [Done] x == 0, y < 0
        [Done] x == 0, y == 0
    [Done] size
        [Done] width > 0, height > 0
        [Done] width > 0, height < 0
        [Done] width > 0, height == 0
        [Done] width < 0, height > 0
        [Done] width < 0, height < 0
        [Done] width < 0, height == 0
        [Done] width == 0, height > 0
        [Done] width == 0, height < 0
        [Done] width == 0, height == 0
 [Done] after notification
    [Done] did show
    [Done] did hide
 [Done] nil user info
 
 */

import XCTest
@testable import SSSugar

class UIViewControllerKBDidChangeHeightTo: XCTestCase {
    //TODO: [Review] Redurant row
    let testHelper = UIViewControllerTestHelper()
    let sut = NotifiableViewController()
    
    override func setUp() {
        sut.registerForKBNotifications()
    }
    
    override func tearDown() {
        sut.unregisterFromKBNotifications()
    }
    
    func testDidShowNotification() {
        for userInfo in testHelper.makeUserInfos() {
            testHelper.postKeyboardDidShowNotification(userInfo: userInfo)
            XCTAssertEqual(sut.keyboardHeight, testHelper.getHeightFromUserInfo(userInfo))
            XCTAssertTrue(sut.isNotified)
        }
    }
    
    func testDidHideNotification() {
        for userInfo in testHelper.makeUserInfos() {
            testHelper.postKeyboardDidHideNotification(userInfo: userInfo)
            XCTAssertEqual(sut.keyboardHeight, 0)
            XCTAssertTrue(sut.isNotified)
        }
    }
    
    func testDidShowNotificationAfterDidShowNotification() {
        testHelper.postKeyboardDidShowNotification(userInfo: testHelper.makeUserInfo())
        sut.reset()
        for userInfo in testHelper.makeUserInfos() {
            testHelper.postKeyboardDidShowNotification(userInfo: userInfo)
            XCTAssertEqual(sut.keyboardHeight, testHelper.getHeightFromUserInfo(userInfo))
            XCTAssertTrue(sut.isNotified)
        }
    }
    
    func testDidHideNotificationAfterDidShowNotification() {
        testHelper.postKeyboardDidShowNotification(userInfo: testHelper.makeUserInfo())
        sut.reset()
        for userInfo in testHelper.makeUserInfos() {
            testHelper.postKeyboardDidHideNotification(userInfo: userInfo)
            XCTAssertEqual(sut.keyboardHeight, 0)
            XCTAssertTrue(sut.isNotified)
        }
    }
    
    func testDidShowNotificationAfterDidHideNotification() {
        testHelper.postKeyboardDidHideNotification(userInfo: testHelper.makeUserInfo())
        sut.reset()
        for userInfo in testHelper.makeUserInfos() {
            testHelper.postKeyboardDidShowNotification(userInfo: userInfo)
            XCTAssertEqual(sut.keyboardHeight, testHelper.getHeightFromUserInfo(userInfo))
            XCTAssertTrue(sut.isNotified)
        }
    }
    
    func testDidHideNotificationAfterDidHideNotification() {
        testHelper.postKeyboardDidHideNotification(userInfo: testHelper.makeUserInfo())
        sut.reset()
        for userInfo in testHelper.makeUserInfos() {
            testHelper.postKeyboardDidHideNotification(userInfo: userInfo)
            XCTAssertEqual(sut.keyboardHeight, 0)
            XCTAssertTrue(sut.isNotified)
        }
    }
    
    func testDidShowNotificationNilUserInfo() {
        testHelper.postKeyboardDidShowNotification()
        XCTAssertEqual(sut.keyboardHeight, NotifiableViewController.defaultKeyboardHight)
        XCTAssertFalse(sut.isNotified)
    }
    
    func testDidHideNotificationNilUserInfo() {
        testHelper.postKeyboardDidHideNotification()
        XCTAssertEqual(sut.keyboardHeight, 0)
        XCTAssertTrue(sut.isNotified)
    }
    
    func testDidShowNotificationAfterDidShowNotificationNilUserInfo() {
        testHelper.postKeyboardDidShowNotification(userInfo: testHelper.makeUserInfo())
        sut.reset()
        testHelper.postKeyboardDidShowNotification()
        XCTAssertEqual(sut.keyboardHeight, NotifiableViewController.defaultKeyboardHight)
        XCTAssertFalse(sut.isNotified)
    }
    
    func testDidHideNotificationAfterDidShowNotificationNilUserInfo() {
        testHelper.postKeyboardDidShowNotification(userInfo: testHelper.makeUserInfo())
        sut.reset()
        testHelper.postKeyboardDidHideNotification()
        XCTAssertEqual(sut.keyboardHeight, 0)
        XCTAssertTrue(sut.isNotified)
    }
    
    func testDidShowNotificationAfterDidHideNotificationNilUserInfo() {
        testHelper.postKeyboardDidHideNotification(userInfo: testHelper.makeUserInfo())
        sut.reset()
        testHelper.postKeyboardDidShowNotification()
        XCTAssertEqual(sut.keyboardHeight, NotifiableViewController.defaultKeyboardHight)
        XCTAssertFalse(sut.isNotified)
    }
    
    func testDidHideNotificationAfterDidHideNotificationNilUserInfo() {
        testHelper.postKeyboardDidHideNotification(userInfo: testHelper.makeUserInfo())
        sut.reset()
        testHelper.postKeyboardDidHideNotification()
        XCTAssertEqual(sut.keyboardHeight, 0)
        XCTAssertTrue(sut.isNotified)
    }
    //TODO: [Review] Redurant row
}
