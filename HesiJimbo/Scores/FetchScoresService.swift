import PromiseKit
import UIKit

protocol FetchScoresService {
	func perform() -> Promise<[ScoreViewModel]>
}

class FetchScoresServiceImpl: FetchScoresService {
	private let session: URLSession

	init(session: URLSession) {
		self.session = session
	}

	func perform() -> Promise<[ScoreViewModel]> {
		let tor = ScoreViewModel.Team(
			name: "Toronto",
			logo: logo(from: "https://cdn.nba.net/assets/logos/teams/secondary/web/TOR.png"),
			score: "100"
		)

		let por = ScoreViewModel.Team(
			name: "Portland",
			logo: logo(from: "https://cdn.nba.net/assets/logos/teams/secondary/web/POR.png"),
			score: "99"
		)

		return Promise.value([
			ScoreViewModel(id: "1", home: tor, away: por, status: "Final", notes: "Hi", theme: .dark),
			ScoreViewModel(id: "2", home: por, away: tor, status: "Final", notes: "Good", theme: .dark),
			ScoreViewModel(id: "3", home: tor, away: por, status: "Final", notes: "", theme: .dark),
			ScoreViewModel(id: "4", home: por, away: tor, status: "Final", notes: "", theme: .dark),
			ScoreViewModel(id: "5", home: tor, away: por, status: "Final", notes: "", theme: .dark)
			])
	}

	private func logo(from url: String) -> Promise<UIImage> {
		return session.dataTask(.promise, with: URLRequest(url: URL(string: url)!))
			.then { (data, response) -> Promise<UIImage> in
				guard let image = UIImage(data: data) else {
					return Promise<UIImage>(error: NSError(domain: "test", code: 1, userInfo: nil))
				}

				return Promise<UIImage>.value(image)
		}
	}
}
