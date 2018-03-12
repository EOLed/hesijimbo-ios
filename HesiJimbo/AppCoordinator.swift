import UIKit

class AppCoordinator {
	private var presentingController: UITabBarController!
	private var coordinator: VideoFeedCoordinator!
	private let dateProvider: DateProvider

	init(dateProvider: DateProvider = DateProviderImpl()) {
		self.dateProvider = dateProvider
	}

	func start(window: UIWindow, theme: Theme) {
		let service = FetchVideoFeedServiceImpl(session: .shared, dateProvider: dateProvider)
		let videos = VideoFeedController(viewModel: VideoFeedViewModel(service: service), theme: .dark)
		videos.tabBarItem = UITabBarItem(
			title: "Videos",
			image: R.image.video(),
			selectedImage: R.image.video()
		)

		presentingController = UITabBarController()
		presentingController.setViewControllers(
			[UINavigationController(rootViewController: videos)],
			animated: false
		)

		let tabBarAppearance = UITabBar.appearance()
		tabBarAppearance.barTintColor = theme.backgroundColor
		tabBarAppearance.tintColor = theme.accentColor

		UIApplication.shared.statusBarStyle = theme.statusBarStyle

		let navBarAppearance = UINavigationBar.appearance()
		navBarAppearance.barTintColor = theme.backgroundColor
		navBarAppearance.tintColor = theme.accentColor
		navBarAppearance.titleTextAttributes = [.foregroundColor : theme.accentColor]

		window.rootViewController = presentingController
		window.makeKeyAndVisible()
	}
}
