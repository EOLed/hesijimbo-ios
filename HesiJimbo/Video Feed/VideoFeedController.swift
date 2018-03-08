import UIKit
import IGListKit
import AVKit
import PromiseKit

class VideoFeedController: UIViewController {
	private lazy var adapter: ListAdapter = {
		return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
	}()

	private var loading = false


	private let listingPromise: Promise<VideoFeedListing>
	private var items: [VideoFeedItem] = []
	private var pagination: Pagination?
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
		guard items.isEmpty else { return }

		_ = listingPromise.done { [weak self] in
			guard let strongSelf = self else { return }

			strongSelf.items.append(contentsOf: $0.items)
			strongSelf.adapter.performUpdates(animated: true, completion: nil)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(collectionView)
		adapter.collectionView = collectionView
		adapter.dataSource = self
		adapter.scrollViewDelegate = self

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
		return items
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

extension VideoFeedController: UIScrollViewDelegate {
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
		if !loading && distance < 200 {
			loading = true
			adapter.performUpdates(animated: true, completion: nil)
			FetchVideoFeedService(session: .shared, dateProvider: DateProviderImpl()).perform(pagination: pagination).done { [weak self] listing in
				guard let strongSelf = self else { return }

				strongSelf.loading = false
				strongSelf.items.append(contentsOf: listing.items)
				strongSelf.pagination = listing.pagination
				strongSelf.adapter.performUpdates(animated: true, completion: nil)
			}
		}
	}
}
