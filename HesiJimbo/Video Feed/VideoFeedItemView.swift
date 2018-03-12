import UIKit
import IGListKit
import AVKit

class VideoFeedItemView: UICollectionViewCell, ListBindable {
	@IBOutlet private weak var title: UILabel!
	@IBOutlet private weak var video: UIView!
	@IBOutlet private weak var preview: UIImageView!
	@IBOutlet private weak var details: UILabel!
	@IBOutlet private weak var play: UIButton!

	private var playerController: AVPlayerViewController?
	private var viewModel: VideoFeedItem?
	private var currentVideoId: String?

	func bindViewModel(_ viewModel: Any) {
		guard let viewModel = viewModel as? VideoFeedItem else {
			fatalError("Can only bind to VideoFeedItem")
		}

		self.viewModel = viewModel
		currentVideoId = viewModel.id

		title.text = viewModel.title
		details.text = viewModel.details

		title.textColor = viewModel.theme.bodyColor
		details.textColor = viewModel.theme.bodyColor

		backgroundColor = viewModel.theme.viewBackgroundColor

		play.titleLabel?.textColor = viewModel.theme.bodyColor

		video.isHidden = true
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

	@IBAction private func tappedPlayButton(_ sender: UIButton) {
		guard let viewModel = viewModel else {
			return
		}

		play.isHidden = true

		_ = viewModel.videoUrl.done { [weak self] url in
			guard let strongSelf = self else {
				return
			}

			strongSelf.preview.isHidden = true
			strongSelf.playVideo(at: url, in: strongSelf.video)
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

	private func isDisplaying(viewModel: VideoFeedItem) -> Bool {
		return currentVideoId == viewModel.id
	}

	private func playVideo(at url: URL, in view: UIView) {
		let controller = buildPlayer(for: url, on: view.bounds)
		guard let player = controller.player else {
			return
		}

		view.addSubview(controller.view)
		view.isHidden = false
		player.play()

		playerController = controller
	}

	private func buildPlayer(for url: URL, on frame: CGRect) -> AVPlayerViewController {
		let player = AVPlayer(url: url)
		let controller = AVPlayerViewController()
		controller.player = player
		controller.view.frame = frame

		return controller
	}

	func destroyPlayer() {
		guard let playerController = playerController else {
			return
		}

		playerController.view.removeFromSuperview()
		playerController.player = nil
		self.playerController = nil
	}

	override func prepareForReuse() {
		video.isHidden = true
		preview.image = nil
		play.isHidden = false
	}
}
