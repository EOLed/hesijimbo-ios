import UIKit

class AppCoordinator {
	private var presentingController: UITabBarController!
	private var coordinator: VideoFeedCoordinator!
	private let dateProvider: DateProvider

	init(dateProvider: DateProvider = DateProviderImpl()) {
		self.dateProvider = dateProvider
	}

	func start(window: UIWindow, theme: Theme) {
		let listing = FetchVideoFeedService(session: .shared, dateProvider: dateProvider).perform()
		let videos = VideoFeedController(listingPromise: listing, theme: .dark)
		videos.tabBarItem = UITabBarItem(title: "Videos", image: R.image.video(), selectedImage: R.image.video())
		
		presentingController = UITabBarController()

		presentingController.setViewControllers(
			[videos],
			animated: false
		)

		let tabBarAppearance = UITabBar.appearance()
		tabBarAppearance.barTintColor = theme.backgroundColor
		tabBarAppearance.tintColor = theme.accentColor

		window.rootViewController = presentingController
		window.makeKeyAndVisible()
	}
}
