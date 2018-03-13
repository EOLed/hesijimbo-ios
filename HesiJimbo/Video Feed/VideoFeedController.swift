import UIKit
import IGListKit
import AVKit
import PromiseKit

class VideoFeedController: UICollectionViewController {
	private lazy var adapter: ListAdapter = {
		return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
	}()

	private let viewModel: VideoFeedViewModel
	private let theme: Theme
	private let refresher: UIRefreshControl

	init(viewModel: VideoFeedViewModel, theme: Theme) {
		self.viewModel = viewModel
		self.theme = theme

		refresher = UIRefreshControl()

		super.init(collectionViewLayout: UICollectionViewFlowLayout())

		refresher.addTarget(self, action: #selector(reload), for: .valueChanged)
		title = viewModel.title
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

		guard let collectionView = collectionView else {
			return
		}

		collectionView.alwaysBounceVertical = true
		collectionView.addSubview(refresher)

		adapter.collectionView = collectionView
		adapter.dataSource = self
		adapter.scrollViewDelegate = self

		collectionView.backgroundColor = theme.backgroundColor
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		collectionView?.frame = view.bounds
	}

	override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
		if !viewModel.isLoading && distance < 200 {
			loadMore()
		}
	}

	@objc private func loadMore() {
		load(request: viewModel.loadMore())
	}

	@objc private func reload() {
		load(request: viewModel.reload())
	}

	private func load(request: Promise<Void>) {
		adapter.performUpdates(animated: true, completion: nil)
		_ = request.done { [weak self] listing in
			guard let strongSelf = self else {
				return
			}

			strongSelf.adapter.performUpdates(animated: false, completion: nil)
			strongSelf.refresher.endRefreshing()
		}
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
	}

	func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
	}

	func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {
	}

	func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
		guard let videoCell = cell as? VideoFeedItemView else {
			return
		}

		videoCell.destroyPlayer()
	}
}
