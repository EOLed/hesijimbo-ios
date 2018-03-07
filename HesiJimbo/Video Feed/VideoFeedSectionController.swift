import IGListKit

class VideoFeedSectionController: ListSectionController {
	private let video: VideoFeedItem

	init(video: VideoFeedItem) {
		self.video = video
	}

	override func sizeForItem(at index: Int) -> CGSize {
		return CGSize(width: collectionContext!.containerSize.width, height: 55)
	}

	override func cellForItem(at index: Int) -> UICollectionViewCell {
		return collectionContext!.dequeueReusableCell(
			withNibName: "VideoFeedItemView",
			bundle: nil,
			for: self,
			at: index
		)
	}
}
