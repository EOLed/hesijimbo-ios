@testable import HesiJimbo

import XCTest

class TeamTest: XCTestCase {
	func testCanFindById() {
		XCTAssertEqual(Team.by(id: "1610612761")!.name, "Raptors")
	}
}
