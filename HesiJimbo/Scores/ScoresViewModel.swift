import Foundation
import PromiseKit

class ScoresViewModel {
	private let service: FetchScoresService
	private(set) var scores: [ScoreViewModel] = []
	private let date: Date
	let title = "Scores"

	init(date: Date, service: FetchScoresService) {
		self.date = date
		self.service = service
	}

	func load() -> Promise<Void> {
		return service.perform().done { [weak self] scores in
			self?.scores.append(contentsOf: scores)
		}
	}
}
