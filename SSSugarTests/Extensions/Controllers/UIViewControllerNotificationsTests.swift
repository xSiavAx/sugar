/*
 Tests for registerForKBNotifications(), unregisterForKBNotifications(), kbDidChangeHeightTo() methods in UIViewController extension

 registerForKBNotifications()
 [Done] keyboard notification
    [Done] did show
    [Done] did hide
 [Done] not keyboard notification
 [Done] notifications sequence
 [Done] nil keyboard user info
 [Done] after remove observer
 
 unregisterForKBNotifications()
 [Done] keyboard notification
    [Done] did show
    [Done] did hide
 
 kbDidChangeHeightTo()
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
 [Done] nil keyboard user info
    
 */

import XCTest
@testable import SSSugar

//TODO: [Review] Are these tests for all Controller's notifications?
class UIViewControllerNotificationsTests: XCTestCase {
    let testHelper = UIViewControllerTestHelper()
    let sut = NotifiableViewController()
    var kbUserInfo: [AnyHashable : Any] { testHelper.defaultNotificationKBUserInfo() }
    
    override func tearDown() {
        sut.removeObserver()
    }
    
    func testRegisterDidShowNotification() {
        testHelper.postKBDidShowNotification(userInfo: kbUserInfo)
        XCTAssertFalse(sut.isNotified)
        //TODO: [Review] Separate logic blocks
        sut.registerForKBNotifications()
        testHelper.postKBDidShowNotification(userInfo: kbUserInfo)
        //TODO: [Review] Redurant row
        XCTAssert(sut.isNotified)
    }
    
    func testRegisterDidHideNotification() {
        testHelper.postKBDidHideNotification(userInfo: kbUserInfo)
        XCTAssertFalse(sut.isNotified)
        sut.registerForKBNotifications()
        testHelper.postKBDidHideNotification(userInfo: kbUserInfo)
        
        XCTAssert(sut.isNotified)
    }
    
    func testRegisterNotKBNotification() {
        sut.registerForKBNotifications()
        testHelper.postCustomNotification(userInfo: kbUserInfo)
        
        XCTAssertFalse(sut.isNotified)
    }
    
    func testRegisterNotificationsSequence() {
        sut.registerForKBNotifications()
        testHelper.postKBDidHideNotification(userInfo: kbUserInfo)
        assertSUTIsNotifiedAndReset()
        testHelper.postKBDidShowNotification(userInfo: kbUserInfo)
        assertSUTIsNotifiedAndReset()
        testHelper.postKBDidShowNotification(userInfo: kbUserInfo)
        assertSUTIsNotifiedAndReset()
        testHelper.postKBDidHideNotification(userInfo: kbUserInfo)
        assertSUTIsNotifiedAndReset()
        testHelper.postKBDidHideNotification(userInfo: kbUserInfo)
        assertSUTIsNotifiedAndReset()
    }
    
    func testRegisterNilUserInfo() {
        sut.registerForKBNotifications()
        testHelper.postKBDidShowNotification(userInfo: nil)
        XCTAssertFalse(sut.isNotified)
        testHelper.postKBDidHideNotification(userInfo: nil)
        
        XCTAssert(sut.isNotified)
    }
    
    func testRegisterAfterRemoveObserver() {
        sut.registerForKBNotifications()
        sut.removeObserver()
        testHelper.postKBDidShowNotification(userInfo: kbUserInfo)
        
        XCTAssertFalse(sut.isNotified)
    }
    
    func testUnregisterDidShowNotification() {
        sut.addDidShowNotificationObserver()
        testHelper.postKBDidShowNotification(userInfo: kbUserInfo)
        assertSUTIsNotifiedAndReset()
        sut.unregisterFromKBNotifications()
        testHelper.postKBDidShowNotification(userInfo: kbUserInfo)
        
        XCTAssertFalse(sut.isNotified)
    }
    
    func testUnregisterDidHideNotification() {
        sut.addDidHideNotificationObserver()
        testHelper.postKBDidHideNotification(userInfo: kbUserInfo)
        assertSUTIsNotifiedAndReset()
        sut.unregisterFromKBNotifications()
        testHelper.postKBDidHideNotification(userInfo: kbUserInfo)
        
        XCTAssertFalse(sut.isNotified)
    }
    
    func testChangeHeightDidShowNotification() {
        sut.registerForKBNotifications()
        for userInfo in testHelper.defaultNotificationKBUserInfos() {
            testHelper.postKBDidShowNotification(userInfo: userInfo)
            
            XCTAssertEqual(sut.keyboardHeight, testHelper.heightFromUserInfo(userInfo))
            XCTAssert(sut.isNotified)
        }
    }
    
    func testChangeHeightDidHideNotification() {
        sut.registerForKBNotifications()
        for userInfo in testHelper.defaultNotificationKBUserInfos() {
            testHelper.postKBDidHideNotification(userInfo: userInfo)
            
            XCTAssertEqual(sut.keyboardHeight, 0)
            XCTAssertTrue(sut.isNotified)
        }
    }
    
    func testChangeHeightNilUserInfo() {
        sut.registerForKBNotifications()
        testHelper.postKBDidHideNotification(userInfo: nil)
        
        XCTAssertEqual(sut.keyboardHeight, 0)
    }
    
    func assertSUTIsNotifiedAndReset() {
        XCTAssert(sut.isNotified)
        sut.reset()
    }
}
