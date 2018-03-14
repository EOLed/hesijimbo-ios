import Foundation
import IGListKit
import PromiseKit

class ScoreViewModel {
	struct Team {
		let name: String
		let logo: String
		let score: String
	}

	let id: String
	let home: Team
	let away: Team
	let status: String
	let notes: String
	let theme: Theme

	private let service: FetchTeamLogoService

	init(id: String, home: Team, away: Team, status: String, notes: String, service: FetchTeamLogoService, theme: Theme) {
		self.id = id
		self.home = home
		self.away = away
		self.status = status
		self.notes = notes
		self.service = service
		self.theme = theme
	}

	func homeLogo() -> Promise<UIImage> {
		return service.perform(url: home.logo)
	}

	func awayLogo() -> Promise<UIImage> {
		return service.perform(url: away.logo)
	}
}

extension ScoreViewModel: ListDiffable {
	func diffIdentifier() -> NSObjectProtocol {
		return id as NSObjectProtocol
	}

	func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
		guard let object = object else { return false }
		return diffIdentifier().isEqual(object.diffIdentifier())
	}
}
