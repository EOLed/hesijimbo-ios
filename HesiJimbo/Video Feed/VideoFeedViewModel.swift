import PromiseKit

class VideoFeedViewModel {
	private(set) var isLoading: Bool
	private(set) var items: [VideoFeedItem] = []
	private var pagination: Pagination?
	private let service: FetchVideoFeedService

	init(service: FetchVideoFeedService) {
		self.service = service
		isLoading = false
	}

	func loadMore() -> Promise<Void> {
		return service.perform(pagination: pagination).done { [weak self] listing in
			guard let strongSelf = self else { return }

			strongSelf.isLoading = false
			strongSelf.items.append(contentsOf: listing.items)
			strongSelf.pagination = listing.pagination
		}
	}
}
