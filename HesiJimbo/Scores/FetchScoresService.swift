import PromiseKit
import UIKit

protocol FetchScoresService {
	func perform() -> Promise<[ScoreViewModel]>
}

class FetchScoresServiceImpl: FetchScoresService {
	private enum Error: Int {
		case invalidUrl
		case invalidResponse

		static let domain = "com.hesijimbo.FetchScoresServiceImpl"
	}

	private let session: URLSession
	private let dateProvider: DateProvider

	init(session: URLSession, dateProvider: DateProvider) {
		self.session = session
		self.dateProvider = dateProvider
	}

	private func scoreboardUrl(for date: Date) -> URL {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyyMMdd"

		guard let url = URL(string: "https://data.nba.net/prod/v2/\(formatter.string(from: date))/scoreboard.json") else {
			fatalError("Could not build scoreboard url")
		}

		return url
	}

	func perform() -> Promise<[ScoreViewModel]> {
		return session.dataTask(.promise, with: URLRequest(url: scoreboardUrl(for: dateProvider.get())))
			.then { self.toDictionary($0.data) }
			.then { self.toViewModels($0) }
	}

	private func toDictionary(_ data: Data) -> Promise<[String : AnyObject]> {
		guard let dictionary = try! JSONSerialization.jsonObject(with: data) as? [String : AnyObject] else {
			return Promise(error: NSError(
				domain: Error.domain,
				code: Error.invalidResponse.rawValue,
				userInfo: nil
			))
		}

		return Promise.value(dictionary)
	}

	private func toViewModels(_ dictionary: [String : AnyObject]) -> Promise<[ScoreViewModel]> {
		guard let games = dictionary["games"] as? [[String : AnyObject]] else {
			return Promise(error: NSError(
				domain: Error.domain,
				code: Error.invalidResponse.rawValue,
				userInfo: nil
			))
		}

		return Promise.value(games.map { toViewModel($0) })
	}

	private func toViewModel(_ dictionary: [String : AnyObject]) -> ScoreViewModel {
		guard let gameId = dictionary["gameId"] as? String,
			let homeTeam = dictionary["hTeam"] as? [String : AnyObject],
			let homeTeamId = homeTeam["teamId"] as? String,
			let homeScore = homeTeam["score"] as? String,
			let awayTeam = dictionary["vTeam"] as? [String : AnyObject],
			let awayTeamId = awayTeam["teamId"] as? String,
			let awayScore = awayTeam["score"] as? String,
			let status = dictionary["statusNum"] as? Int,
			let nugget = dictionary["nugget"] as? [String : AnyObject],
			let notes = nugget["text"] as? String else {
				fatalError("Could not convert dictionary to view model")
		}

		guard let home = Team.by(id: homeTeamId), let away = Team.by(id: awayTeamId) else {
			fatalError("Could not match teams by id")
		}

		let homeViewModel = ScoreViewModel.Team(
			name: home.city,
			logo: "https://cdn.nba.net/assets/logos/teams/secondary/web/\(home.triCode).png",
			score: homeScore
		)

		let awayViewModel = ScoreViewModel.Team(
			name: away.city,
			logo: "https://cdn.nba.net/assets/logos/teams/secondary/web/\(away.triCode).png",
			score: awayScore
		)

		return ScoreViewModel(
			id: gameId,
			home: homeViewModel,
			away: awayViewModel,
			status: status == 3 ? "Final" : "",
			notes: notes,
			service: FetchTeamLogoServiceImpl(session: session),
			theme: .dark
		)
	}
}
