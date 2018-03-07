import UIKit

class AppCoordinator {
	private lazy var presentingController: UINavigationController = {
		return UINavigationController(rootViewController: UIViewController())
	}()

	private var coordinator: VideoFeedCoordinator!

	func start(window: UIWindow, theme: Theme) {
		window.rootViewController = presentingController
		window.makeKeyAndVisible()

		coordinator = VideoFeedCoordinator(presentingController: presentingController, session: .shared, theme: theme)
		coordinator.start()
	}
}
