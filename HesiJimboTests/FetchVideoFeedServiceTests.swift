import XCTest
import DVR

@testable import HesiJimbo

class FetchVideoFeedServiceTests: XCTestCase {
	func testFetchVideoFeedListing() {
		let session = Session(cassetteName: "FetchVideoFeedServiceTests_testFetchVideoFeedListing")
		let service = FetchVideoFeedService(
			session: session,
			dateProvider: MockDateProvider(now: Date(timeIntervalSince1970: 1520473890.0))
		)

		let expectation = XCTestExpectation()
		let thumbnailExpectation = XCTestExpectation()
		let videoExpectation = XCTestExpectation()

		_ = service.perform().done { listing in
			XCTAssertNil(listing.pagination.before)
			XCTAssertEqual(listing.pagination.after, "t3_82nbk7")
			XCTAssertEqual(listing.items.count, 12)

			let item = listing.items.first!
			XCTAssertEqual(item.id, "82u5ir")
			XCTAssertEqual(item.title, "Joe Ingles throws a towel in the face of Jazz Announcer Matt Harpring")
			XCTAssertEqual(item.url.absoluteString, "https://streamable.com/34nod")

			// can't use DVR on these because URLSession is not injectable in OpenGraph
			_ = item.thumbnailUrl.done { _ in thumbnailExpectation.fulfill() }
			_ = item.videoUrl.done { _ in videoExpectation.fulfill() }

			XCTAssertEqual(item.details, "0s • PoohBear075")

			expectation.fulfill()
		}

		wait(for: [expectation, thumbnailExpectation, videoExpectation], timeout: 10)
	}
}
