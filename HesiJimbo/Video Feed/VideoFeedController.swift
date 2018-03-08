import UIKit
import IGListKit
import AVKit
import PromiseKit

class VideoFeedController: UIViewController {
	private lazy var adapter: ListAdapter = {
		return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
	}()

	private let listingPromise: Promise<VideoFeedListing>
	private var listing: VideoFeedListing?
	private let theme: Theme
	private let collectionView = UICollectionView(
		frame: .zero,
		collectionViewLayout: UICollectionViewFlowLayout()
	)

	init(listingPromise: Promise<VideoFeedListing>, theme: Theme) {
		self.listingPromise = listingPromise
		self.theme = theme
		super.init(nibName: "VideoFeed", bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) is not supported")
	}

	override func viewWillAppear(_ animated: Bool) {
		guard listing == nil else { return }

		_ = listingPromise.done { [weak self] in
			guard let strongSelf = self else { return }

			strongSelf.listing = $0
			strongSelf.adapter.reloadData()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(collectionView)
		adapter.collectionView = collectionView
		adapter.dataSource = self

		collectionView.backgroundColor = theme.backgroundColor

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
		guard let listing = listing else { return [] }

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
		return nil
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
