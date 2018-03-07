import UIKit

class VideoFeedItemView: UICollectionViewCell {
	@IBOutlet private weak var title: UILabel!
	@IBOutlet private weak var video: UIView!
	@IBOutlet private weak var preview: UIImageView!
	@IBOutlet private weak var details: UILabel!

	func bind(to viewModel: VideoFeedItem) {
		title.text = viewModel.title
		details.text = viewModel.details
	}
}
