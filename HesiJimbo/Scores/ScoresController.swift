import UIKit
import IGListKit
import PromiseKit

class ScoresController: UICollectionViewController {
	private lazy var adapter: ListAdapter = {
		return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
	}()

	private let viewModel: ScoresViewModel
	private let theme: Theme
	private let refresher: UIRefreshControl

	init(viewModel: ScoresViewModel, theme: Theme) {
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
		guard viewModel.scores.isEmpty else { return }

		_ = viewModel.load().done { [weak adapter] in
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

	@objc private func reload() {
		load(request: viewModel.load())
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
}

extension ScoresController: ListAdapterDataSource {
	func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
		return viewModel.scores
	}

	func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
		if let score = object as? ScoreViewModel {
			return ScoreSectionController(score: score)
		}

		fatalError("No controller found for item")
	}

	func emptyView(for listAdapter: ListAdapter) -> UIView? {
		return nil
	}
}
