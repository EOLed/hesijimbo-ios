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
	let score: Int
	let theme: Theme

	init(
		id: String,
		title: String,
		url: URL,
		thumbnailUrl: Promise<URL>,
		videoUrl: Promise<URL>,
		postedAt: Date,
		author: String,
		score: Int,
		theme: Theme,
		dateProvider: DateProvider
		) {
		self.id = id
		self.title = title
		self.url = url
		self.thumbnailUrl = thumbnailUrl
		self.videoUrl = videoUrl
		self.score = score
		self.theme = theme

		let prettyNumbers = PrettyNumbers(dateProvider: dateProvider)

		self.details = "\(prettyNumbers.timeAgo(epochUtc: Int(postedAt.timeIntervalSince1970))) • \(author)"
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
