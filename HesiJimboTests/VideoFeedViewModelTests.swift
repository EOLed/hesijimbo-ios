@testable import HesiJimbo

import XCTest
import PromiseKit

class VideoFeedViewModelTests: XCTestCase {
	func testLoadMore() {
		var resolver: Resolver<VideoFeedListing>!
		let promise: Promise<VideoFeedListing> = Promise<VideoFeedListing> { seal in
			resolver = seal
		}
		let service = MockFetchVideoFeedService(promise: promise)
		let model = VideoFeedViewModel(service: service)

		var expectation = XCTestExpectation()
		_ = model.loadMore().done {
			expectation.fulfill()
		}

		XCTAssertTrue(model.isLoading)

		var listing: VideoFeedListing = (
			items: [createItem(id: "1")],
			pagination: .beginning(after: "asdf")
		)

		resolver.fulfill(listing)

		wait(for: [expectation], timeout: 1)

		XCTAssertFalse(model.isLoading)
		XCTAssertEqual(model.items.map { $0.id }, listing.items.map { $0.id })

		service.promise = Promise<VideoFeedListing> { seal in
			resolver = seal
		}

		expectation = XCTestExpectation()
		_ = model.loadMore().done {
			expectation.fulfill()
		}

		listing = (
			items: [createItem(id: "2"), createItem(id: "3")],
			pagination: .middle(before: "asdf", after: "fdas")
		)

		resolver.fulfill(listing)

		wait(for: [expectation], timeout: 1)

		XCTAssertEqual(model.items.map { $0.id }, ["1", "2", "3"])
	}

	private func createItem(id: String) -> VideoFeedItem {
		return VideoFeedItem(
			id: id,
			title: "",
			url: URL(string: "http://www.example.com")!,
			thumbnailUrl: Promise(error: NSError(domain: "Test", code: 1, userInfo: nil)),
			videoUrl: Promise(error: NSError(domain: "Test", code: 1, userInfo: nil)),
			postedAt: Date(),
			author: "Test User",
			score: 10,
			theme: .dark,
			dateProvider: DateProviderImpl()
		)
	}
}
