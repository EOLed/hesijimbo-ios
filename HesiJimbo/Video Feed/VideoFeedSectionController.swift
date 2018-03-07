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
		return CGSize(width: collectionContext!.containerSize.width, height: 300)
	}

	func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
		guard let model = object as? VideoFeedItem else {
			fatalError("Object not supported")
		}

		return [model]
	}
}
