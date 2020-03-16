import XCTest

class SSCollectionViewMarkableControllerDeactivateTC: SSCollectionViewMarkableControllerDeactivateAlreadyDeactiveTC {

    override func setUp() {
        super.setUp()
        controller.setActive(true)
    }
}
