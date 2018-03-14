import XCTest
import DVR

@testable import HesiJimbo

class FetchScoresServiceTests: XCTestCase {
	func testFetchScores() {
		let session = Session(cassetteName: "FetchScoresServiceTests_testFetchScores")
		let service = FetchScoresServiceImpl(session: session)

		let expectation = XCTestExpectation()
		_ = service.perform().done { scores in
			let score = scores.first!
//			XCTAssertEqual(score.id, "1234")
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 10)
	}
}
