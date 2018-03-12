import IGListKit

class VideoFeedSectionController: ListBindingSectionController<VideoFeedItem>, ListBindingSectionControllerDataSource {
	let video: VideoFeedItem

	init(video: VideoFeedItem) {
		self.video = video
		super.init()
		dataSource = self
		inset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
	}

	func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
		return collectionContext!.dequeueReusableCell(
			withNibName: "VideoFeedItemView",
			bundle: nil,
			for: self,
			at: index
		) as! VideoFeedItemView
	}

	func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
		guard let viewModel = viewModel as? VideoFeedItem else {
			fatalError("Only VideoFeedItem objects are supported")
		}

		return CGSize(
			width: collectionContext!.containerSize.width,
			height: height(for: viewModel)
		)
	}

	func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
		guard let model = object as? VideoFeedItem else {
			fatalError("Object not supported")
		}

		return [model]
	}

	private func height(for viewModel: VideoFeedItem) -> CGFloat {
		let titleFont = UIFont.preferredFont(forTextStyle: .title3)
		let detailsFont = UIFont.preferredFont(forTextStyle: .footnote)
		let spacerWidth: CGFloat = 10.0
		let width = collectionContext!.containerSize.width - spacerWidth - spacerWidth

		let titleHeight = TextSize.size(viewModel.title, font: titleFont, width: width).height
		let detailsHeight = TextSize.size(viewModel.details, font: detailsFont, width: width).height
		let thumbnailHeight: CGFloat = width / (16 / 9.0)
		let spacerHeight: CGFloat = 10.0

		return spacerHeight + titleHeight + spacerHeight + thumbnailHeight + spacerHeight + detailsHeight + spacerHeight + spacerHeight
	}
}
