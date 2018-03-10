import UIKit
import IGListKit
import AVKit

class VideoFeedItemView: UICollectionViewCell, ListBindable {
	@IBOutlet private weak var title: UILabel!
	@IBOutlet weak var video: UIView!
	@IBOutlet weak var preview: UIImageView!
	@IBOutlet private weak var details: UILabel!

	@IBOutlet private var playerController: AVPlayerViewController!

	func bindViewModel(_ viewModel: Any) {
		guard let viewModel = viewModel as? VideoFeedItem else {
			fatalError("Can only bind to VideoFeedItem")
		}

		title.text = viewModel.title
		details.text = viewModel.details

		title.textColor = viewModel.theme.bodyColor
		details.textColor = viewModel.theme.bodyColor

		backgroundColor = viewModel.theme.viewBackgroundColor

		video.isHidden = true

		_ = viewModel.thumbnailUrl.done(on: DispatchQueue.global(qos: .background)) { [weak self] url in
			guard let data = try? Data(contentsOf: url) else {
				return
			}

			DispatchQueue.main.async {
				self?.preview.image = UIImage(data: data)
				self?.preview.isHidden = false
			}
		}
	}

	func setUpPlayer(url: URL) {
		let player = AVPlayer(url: url)
		playerController = AVPlayerViewController()
		playerController.player = player

		video.addSubview(playerController.view)
		video.isHidden = false
		playerController.view.frame = video.bounds
	}

	func destroyPlayer() {
		playerController.view.removeFromSuperview()
		playerController.player = nil
		playerController = nil
	}

	override func prepareForReuse() {
		video.isHidden = true
		preview.isHidden = true
	}

	override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
		setNeedsLayout()
		layoutIfNeeded()

		let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)

		var newFrame = layoutAttributes.frame
		newFrame.size.height = ceil(size.height)

		layoutAttributes.frame = newFrame

		return layoutAttributes
	}
}
