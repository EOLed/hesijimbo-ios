@testable import HesiJimbo

import PromiseKit

class MockFetchVideoFeedService: FetchVideoFeedService {
	var promise: Promise<VideoFeedListing>
	var pagination: Pagination?

	init(promise: Promise<VideoFeedListing>) {
		self.promise = promise
	}

	func perform(pagination: Pagination?) -> Promise<VideoFeedListing> {
		self.pagination = pagination
		return promise
	}
}
