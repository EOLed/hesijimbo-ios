import UIKit
import IGListKit
import PromiseKit

class ScoreView: UICollectionViewCell, ListBindable {
	@IBOutlet private weak var homeLogo: UIImageView!
	@IBOutlet private weak var home: UILabel!
	@IBOutlet private weak var homeScore: UILabel!

	@IBOutlet private weak var awayLogo: UIImageView!
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

		home.text = viewModel.home.name
		away.text = viewModel.away.name

		homeScore.text = viewModel.home.score
		awayScore.text = viewModel.away.score

		status.text = viewModel.status
		notes.text = viewModel.notes

		load(logo: viewModel.home.logo, on: homeLogo)
		load(logo: viewModel.away.logo, on: awayLogo)
	}
	

	private func load(logo: Promise<UIImage>, on imageView: UIImageView) {
		_ = logo.done(on: DispatchQueue.global(qos: .background)) { logoImage in
			DispatchQueue.main.async {
				imageView.image = logoImage
				imageView.contentMode = .scaleAspectFit
				imageView.clipsToBounds = true
			}
		}
	}
}
