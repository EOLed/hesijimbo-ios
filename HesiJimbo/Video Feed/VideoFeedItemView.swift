import UIKit
import IGListKit
import AVKit

class VideoFeedItemView: UICollectionViewCell, ListBindable {
	@IBOutlet private weak var title: UILabel!
	@IBOutlet weak var video: UIView!
	@IBOutlet weak var preview: UIImageView!
	@IBOutlet private weak var details: UILabel!

	@IBOutlet private var playerController: AVPlayerViewController!

	private var currentVideoId: String?

	func bindViewModel(_ viewModel: Any) {
		guard let viewModel = viewModel as? VideoFeedItem else {
			fatalError("Can only bind to VideoFeedItem")
		}

		currentVideoId = viewModel.id

		title.text = viewModel.title
		details.text = viewModel.details

		title.textColor = viewModel.theme.bodyColor
		details.textColor = viewModel.theme.bodyColor

		backgroundColor = viewModel.theme.viewBackgroundColor

//		video.isHidden = true
		preview.image = nil


		_ = viewModel.thumbnailUrl.done(on: DispatchQueue.global(qos: .background)) { [weak self] url in
			guard let strongSelf = self else {
				return
			}

			guard strongSelf.isDisplaying(viewModel: viewModel) else {
				print("No longer displaying viewModel: \(viewModel.id)")
				return
			}

			guard let data = try? Data(contentsOf: url) else {
				return
			}

			DispatchQueue.main.async {
				guard strongSelf.isDisplaying(viewModel: viewModel) else {
					print("No longer displaying viewModel: \(viewModel.id)")
					return
				}

				strongSelf.setPreview(data: data)
			}
		}
	}

	private func setPreview(data: Data) {
		guard let previewImage = UIImage(data: data) else {
			return
		}

		preview.image = previewImage
		preview.contentMode = contentMode(for: previewImage.size)
		preview.clipsToBounds = true
		preview.isHidden = false
	}

	private func contentMode(for size: CGSize) -> UIViewContentMode {
		if size.width > size.height {
			return .scaleAspectFill
		}

		return .scaleAspectFit
	}

	func isDisplaying(viewModel: VideoFeedItem) -> Bool {
		return currentVideoId == viewModel.id
	}

	func setUpPlayer(url: URL, viewModel: VideoFeedItem) {
		guard isDisplaying(viewModel: viewModel) else {
			print("No longer displaying viewModel: \(viewModel.id)")
			return
		}

		print("Showing player: \(viewModel.title)")

		let player = AVPlayer(url: url)
		let controller = AVPlayerViewController()
		controller.player = player
		controller.view.frame = video.bounds

		video.addSubview(controller.view)
		video.isHidden = false

		playerController = controller
	}

	func destroyPlayer() {
		guard let playerController = playerController else {
			return
		}

		playerController.view.removeFromSuperview()
		playerController.player = nil
		self.playerController = nil
		currentVideoId = nil
	}

//	override func prepareForReuse() {
//		currentVideoId = nil
//		video.isHidden = true
//		preview.image = nil
//	}

//	override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//		setNeedsLayout()
//		layoutIfNeeded()
//
//		let size = contentView.systemLayoutSizeFitting(
//			CGSize(
//				width: layoutAttributes.frame.width,
//				height: CGFloat.greatestFiniteMagnitude
//			),
//			withHorizontalFittingPriority: .required,
//			verticalFittingPriority: .fittingSizeLevel
//		)
//
//		layoutAttributes.frame.size = size
//
//		return layoutAttributes
//	}
}
