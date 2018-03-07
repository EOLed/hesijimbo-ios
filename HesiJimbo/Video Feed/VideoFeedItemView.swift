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

//		preview.backgroundColor = UIColor(red:0.1, green:0.1, blue:0.1, alpha:1.0)
//
//		_ = viewModel.thumbnailUrl.done { thumbnailUrl in
//			print("fetching \(thumbnailUrl.absoluteString)")
//			_ = URLSession.shared.dataTask(.promise, with: URLRequest(url: thumbnailUrl)).done { [weak self] response in
//				self?.preview.image = UIImage(data: response.data)
//			}
//		}


//		_ = viewModel.videoUrl.done { [weak self] url in
//			guard let strongSelf = self else { return }
//
//			print("loading video for \(viewModel.id): \(url.absoluteString)")
//			//			videoCell.preview.isHidden = true
//
//			let player = AVPlayer(url: url)
//			strongSelf.playerController = AVPlayerViewController()
//			strongSelf.playerController.player = player
//			strongSelf.playerController.view.frame = strongSelf.video.frame
//
//			strongSelf.video.addSubview(strongSelf.playerController.view)
//			strongSelf.video.isHidden = false
//		}

	}
}
