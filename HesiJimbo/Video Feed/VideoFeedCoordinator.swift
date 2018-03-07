import UIKit

class VideoFeedCoordinator {
	private weak var presentingController: UINavigationController!
	private let session: URLSession

	init(presentingController: UINavigationController, session: URLSession) {
		self.presentingController = presentingController
		self.session = session
	}

	func start() {
		_ = FetchVideoFeedService(session: session).perform().done { [presentingController] listing in
			guard let presentingController = presentingController else { return }

			let controller = VideoFeedController(listing: listing)
			presentingController.pushViewController(controller, animated: true)
		}
	}
}
