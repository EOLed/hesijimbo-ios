import UIKit
import IGListKit

class ScoreView: UICollectionViewCell, ListBindable {
	@IBOutlet private weak var homeLogo: UIView!
	@IBOutlet private weak var home: UILabel!
	@IBOutlet private weak var homeScore: UILabel!

	@IBOutlet private weak var awayLogo: UIView!
	@IBOutlet private weak var away: UILabel!
	@IBOutlet private weak var awayScore: UILabel!

	@IBOutlet private weak var status: UILabel!
	@IBOutlet private weak var notes: UILabel!

	private enum State {
		case bound(score: ScoreViewModel)
		case unbound
	}

	private var state = State.unbound

	func bindViewModel(_ viewModel: Any) {
		guard let viewModel = viewModel as? ScoreViewModel else {
			fatalError("Can only bind to ScoreViewModel")
		}

		state = .bound(score: viewModel)
		backgroundColor = viewModel.theme.viewBackgroundColor

		home.textColor = viewModel.theme.bodyColor
		away.textColor = viewModel.theme.bodyColor
		homeScore.textColor = viewModel.theme.bodyColor
		awayScore.textColor = viewModel.theme.bodyColor
		notes.textColor = viewModel.theme.subtleColor
		status.textColor = viewModel.theme.bodyColor
	}
}
