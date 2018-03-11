import UIKit
import IGListKit
import AVKit
import PromiseKit

class VideoFeedController: UIViewController {
	private lazy var adapter: ListAdapter = {
		return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
	}()

	private let viewModel: VideoFeedViewModel
	private let theme: Theme
	private let collectionView = UICollectionView(
		frame: .zero,
		collectionViewLayout: UICollectionViewFlowLayout()
	)

	init(viewModel: VideoFeedViewModel, theme: Theme) {
		self.viewModel = viewModel
		self.theme = theme
		super.init(nibName: "VideoFeed", bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) is not supported")
	}

	override func viewWillAppear(_ animated: Bool) {
		guard viewModel.items.isEmpty else { return }

		_ = viewModel.loadMore().done { [weak adapter] in
			adapter?.performUpdates(animated: true, completion: nil)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(collectionView)
		adapter.collectionView = collectionView
		adapter.dataSource = self
		adapter.scrollViewDelegate = self

		collectionView.backgroundColor = theme.backgroundColor

//		if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//			flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
//		}
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
		return viewModel.items
	}

	func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
		if let video = object as? VideoFeedItem {
			let controller = VideoFeedSectionController(video: video)
//			controller.displayDelegate = self
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

		_ = videoItem.videoUrl.done(on: DispatchQueue.global(qos: .background)) {
			videoCell.setUpPlayer(url: $0, viewModel: videoItem)
		}
	}

	func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {

	}

	func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {
	}

	func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
		(cell as? VideoFeedItemView)?.destroyPlayer()
	}
}

extension VideoFeedController: UIScrollViewDelegate {
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
		if !viewModel.isLoading && distance < 200 {
			adapter.performUpdates(animated: true, completion: nil)
			_ = viewModel.loadMore().done { [weak adapter] listing in
				adapter?.performUpdates(animated: false, completion: nil)
			}
		}
	}
}
