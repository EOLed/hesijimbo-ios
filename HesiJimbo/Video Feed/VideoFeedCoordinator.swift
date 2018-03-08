import UIKit

class VideoFeedCoordinator {
	private weak var presentingController: UINavigationController!
	private let session: URLSession
	private let dateProvider: DateProvider
	private let theme: Theme

	init(presentingController: UINavigationController, session: URLSession, dateProvider: DateProvider, theme: Theme) {
		self.presentingController = presentingController
		self.session = session
		self.dateProvider = dateProvider
		self.theme = theme
	}

	func start() {
		let controller = VideoFeedController(
			listingPromise: FetchVideoFeedService(session: session, dateProvider: dateProvider).perform(),
			theme: theme
		)

		presentingController.pushViewController(controller, animated: true)
	}
}
