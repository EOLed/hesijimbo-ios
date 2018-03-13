import PromiseKit

protocol FetchScoresService {
	func perform() -> Promise<[ScoreViewModel]>
}

class FetchScoresServiceImpl: FetchScoresService {
	func perform() -> Promise<[ScoreViewModel]> {
		let tor = ScoreViewModel.Team(
			name: "Toronto",
			logo: URL(string: "https://stats.nba.com/media/img/teams/logos/TOR_logo.svg")!,
			score: "100"
		)

		let por = ScoreViewModel.Team(
			name: "Portland",
			logo: URL(string: "https://stats.nba.com/media/img/teams/logos/POR_logo.svg")!,
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
}
