import PromiseKit

class VideoFeedViewModel {
	private(set) var isLoading: Bool
	private(set) var items: [VideoFeedItem] = []
	private var pagination: Pagination?
	private let service: FetchVideoFeedService
	let title = "Videos"

	init(service: FetchVideoFeedService) {
		self.service = service
		isLoading = false
	}

	@discardableResult
	func reload() -> Promise<Void> {
		isLoading = true
		items = []
		return service.perform(pagination: nil).done { [weak self] listing in
			self?.loaded(listing: listing)
		}
	}

	@discardableResult
	func loadMore() -> Promise<Void> {
		isLoading = true
		return service.perform(pagination: pagination).done { [weak self] listing in
			self?.loaded(listing: listing)
		}
	}

	private func loaded(listing: VideoFeedListing) {
		isLoading = false
		items.append(contentsOf: listing.items)
		pagination = listing.pagination
	}
}
