import UIKit

class VideoFeedCoordinator {
	private weak var presentingController: UINavigationController!
	private let session: URLSession
	private let theme: Theme

	init(presentingController: UINavigationController, session: URLSession, theme: Theme) {
		self.presentingController = presentingController
		self.session = session
		self.theme = theme
	}

	func start() {
		_ = FetchVideoFeedService(session: session).perform().done { [weak self] listing in
			guard let strongSelf = self else { return }

			let controller = VideoFeedController(listing: listing, theme: strongSelf.theme)
			strongSelf.presentingController.pushViewController(controller, animated: true)
		}
	}
}
