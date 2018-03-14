import XCTest
import DVR

@testable import HesiJimbo

class FetchScoresServiceTests: XCTestCase {
	func testFetchScores() {
		let session = Session(cassetteName: "FetchScoresServiceTests_testFetchScores")
		let service = FetchScoresServiceImpl(
			session: session,
			dateProvider: MockDateProvider(now: Date(timeIntervalSince1970: 1520913800))
		)

		let expectation = XCTestExpectation()
		_ = service.perform().done { scores in
			let score = scores.first!
			XCTAssertEqual(score.id, "0021701005")
			XCTAssertEqual(score.notes, "Turner: 25 pts; Young: 19 pts, 10 reb")

			XCTAssertEqual(score.home.name, "Philadelphia")
			XCTAssertEqual(score.home.score, "98")
			XCTAssertEqual(score.home.logo, "https://cdn.nba.net/assets/logos/teams/secondary/web/PHI.png")

			XCTAssertEqual(score.away.name, "Indiana")
			XCTAssertEqual(score.away.score, "101")
			XCTAssertEqual(score.away.logo, "https://cdn.nba.net/assets/logos/teams/secondary/web/IND.png")

			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 10)
	}
}
