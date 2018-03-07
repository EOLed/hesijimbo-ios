import UIKit
import IGListKit
import AVKit

class VideoFeedController: UIViewController {
	private lazy var adapter: ListAdapter = {
		return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
	}()

	private let listing: VideoFeedListing
	private let collectionView = UICollectionView(
		frame: .zero,
		collectionViewLayout: UICollectionViewFlowLayout()
	)

	init(listing: VideoFeedListing) {
		self.listing = listing
		super.init(nibName: "VideoFeed", bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) is not supported")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(collectionView)
		adapter.collectionView = collectionView
		adapter.dataSource = self

		collectionView.backgroundColor = .white

		if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
		}
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		collectionView.frame = view.bounds
	}

	deinit {
		print("bye VideoFeedController")
	}
}

extension VideoFeedController: ListAdapterDataSource {
	func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
		return listing.items
	}

	func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
		if let video = object as? VideoFeedItem {
			let controller = VideoFeedSectionController(video: video)
			controller.displayDelegate = self
			return controller
		}

		fatalError("No controller found for item")
	}

	func emptyView(for listAdapter: ListAdapter) -> UIView? {
		let view = UIView()
		view.backgroundColor = .blue
		return view
	}
}

extension VideoFeedController: ListDisplayDelegate {
	func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
		guard let videoCell = cell as? VideoFeedItemView else {
			return
		}

		guard let videoSectionController = sectionController as? VideoFeedSectionController else {
			return
		}

		let videoItem = videoSectionController.video

		_ = videoItem.videoUrl.done { [weak self] url in
			guard let strongSelf = self else { return }

			print("loading video for \(videoItem.id): \(url.absoluteString)")
//			videoCell.preview.isHidden = true

			let player = AVPlayer(url: url)
			let controller = AVPlayerViewController()
			controller.player = player

			strongSelf.addChildViewController(controller)
			videoCell.video.addSubview(controller.view)
			videoCell.video.isHidden = false
			controller.view.frame = videoCell.video.bounds

		}
	}

	func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {

	}

	func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {

	}

	func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {

	}
}
