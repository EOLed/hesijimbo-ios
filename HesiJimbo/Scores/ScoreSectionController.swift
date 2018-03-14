import IGListKit

class ScoreSectionController: ListBindingSectionController<ScoreViewModel>, ListBindingSectionControllerDataSource {
	let score: ScoreViewModel

	init(score: ScoreViewModel) {
		self.score = score
		super.init()
		dataSource = self
		inset = UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
	}

	func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
		return collectionContext!.dequeueReusableCell(
			withNibName: "Score",
			bundle: nil,
			for: self,
			at: index
			) as! ScoreView
	}

	func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
		guard let viewModel = viewModel as? ScoreViewModel else {
			fatalError("Only ScoreViewModel objects are supported")
		}

		return CGSize(
			width: collectionContext!.containerSize.width,
			height: height(for: viewModel)
		)
	}

	func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
		guard let model = object as? ScoreViewModel else {
			fatalError("Object not supported")
		}

		return [model]
	}

	private func height(for viewModel: ScoreViewModel) -> CGFloat {
		let scoreLineFont = UIFont.preferredFont(forTextStyle: .body)
		let notesFont = UIFont.preferredFont(forTextStyle: .footnote)
		let spacerWidth: CGFloat = 10.0
		let width = collectionContext!.containerSize.width - spacerWidth - spacerWidth

		let scoreLineHeight = TextSize.size(viewModel.home.name, font: scoreLineFont, width: width).height
		let notesHeight = TextSize.size(viewModel.notes, font: notesFont, width: width).height
		let teamSpacerHeight: CGFloat = 8.0
		let spacerHeight: CGFloat = 10.0

		return spacerHeight + scoreLineHeight + teamSpacerHeight + scoreLineHeight + spacerHeight + notesHeight + spacerHeight
	}
}
