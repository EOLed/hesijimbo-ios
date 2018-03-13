import XCTest
import PromiseKit

@testable import HesiJimbo

class VideoFeedItemTests: XCTestCase {
	func testDetailsFormatting() {
		let item = VideoFeedItem(
			id: "82fqle",
			title: "Title",
			url: URL(string: "http://example.com")!,
			thumbnailUrl: Promise(error: NSError(domain: "Test", code: 1, userInfo: nil)),
			videoUrl: Promise(error: NSError(domain: "Test", code: 2, userInfo: nil)),
			postedAt: Date(timeIntervalSince1970: 1520273890),
			author: "magnanamos",
			score: 100,
			theme: .dark,
			dateProvider: MockDateProvider(now: Date(timeIntervalSince1970: 1520473890))
		)

		XCTAssertEqual(item.details, "2d • magnanamos")
	}
}
