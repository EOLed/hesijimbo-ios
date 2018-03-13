import UIKit

class AppCoordinator {
	private var presentingController: UITabBarController!
	private let dateProvider: DateProvider

	init(dateProvider: DateProvider = DateProviderImpl()) {
		self.dateProvider = dateProvider
	}

	func start(window: UIWindow, theme: Theme) {
		presentingController = UITabBarController()
		presentingController.setViewControllers(
			[
				buildVideosController(),
				buildScoresController()
			],
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

	private func buildVideosController() -> UINavigationController {
		let service = FetchVideoFeedServiceImpl(session: .shared, dateProvider: dateProvider)
		let videos = VideoFeedController(viewModel: VideoFeedViewModel(service: service), theme: .dark)
		videos.tabBarItem = UITabBarItem(
			title: "Videos",
			image: R.image.tabVideos(),
			selectedImage: R.image.tabVideos()
		)

		return UINavigationController(rootViewController: videos)
	}

	private func buildScoresController() -> UINavigationController {
		let service = FetchScoresServiceImpl()
		let scores = ScoresController(
			viewModel: ScoresViewModel(date: dateProvider.get(), service: service),
			theme: .dark
		)

		scores.tabBarItem = UITabBarItem(
			title: "Scores",
			image: R.image.tabScores(),
			selectedImage: R.image.tabScores()
		)

		return UINavigationController(rootViewController: scores)
	}
}
