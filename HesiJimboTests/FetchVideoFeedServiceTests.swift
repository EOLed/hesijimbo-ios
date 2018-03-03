import XCTest
import DVR

@testable import HesiJimbo

class FetchVideoFeedServiceTests: XCTestCase {
	func testFetchVideoFeedListing() {
		let session = Session(cassetteName: "FetchVideoFeedServiceTests_testFetchVideoFeedListing")
		let service = FetchVideoFeedService(session: session)

		let expectation = XCTestExpectation()
		let thumbnailExpectation = XCTestExpectation()
		let videoExpectation = XCTestExpectation()

		_ = service.perform().done { listing in
			XCTAssertNil(listing.pagination.before)
			XCTAssertEqual(listing.pagination.after, "t3_822ar8")
			XCTAssertEqual(listing.items.count, 9)

			let item = listing.items.first!
			XCTAssertEqual(item.title, "Robert Sacre competes in dunk contest in Japan")
			XCTAssertEqual(item.url.absoluteString, "https://streamable.com/4bvun")

			// can't use DVR on these because URLSession is not injectable in OpenGraph
			_ = item.thumbnailUrl.done { _ in thumbnailExpectation.fulfill() }
			_ = item.videoUrl.done { _ in videoExpectation.fulfill() }

			XCTAssertEqual(item.postedAt.timeIntervalSince1970, 1520194052)
			XCTAssertEqual(item.author, "TraeRoyalty")

			expectation.fulfill()
		}

		wait(for: [expectation, thumbnailExpectation, videoExpectation], timeout: 10)
	}
}
