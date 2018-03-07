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
