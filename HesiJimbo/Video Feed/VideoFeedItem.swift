import Foundation
import PromiseKit
import IGListKit

class VideoFeedItem {
	let id: String
	let title: String
	let url: URL
	let thumbnailUrl: Promise<URL>
	let videoUrl: Promise<URL>
	let details: String

	init(
		id: String,
		title: String,
		url: URL,
		thumbnailUrl: Promise<URL>,
		videoUrl: Promise<URL>,
		postedAt: Date,
		author: String
		) {
		self.id = id
		self.title = title
		self.url = url
		self.thumbnailUrl = thumbnailUrl
		self.videoUrl = videoUrl

		self.details = author
	}
}

extension VideoFeedItem: ListDiffable {
	func diffIdentifier() -> NSObjectProtocol {
		return id as NSString
	}

	func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
		guard let object = object else { return false }
		return diffIdentifier().isEqual(object.diffIdentifier())
	}
}
