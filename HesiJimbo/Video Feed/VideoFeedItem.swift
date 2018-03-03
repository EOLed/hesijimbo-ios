import Foundation
import PromiseKit

struct VideoFeedItem {
	let title: String
	let url: URL
	let thumbnailUrl: Promise<URL>
	let videoUrl: Promise<URL>
	let postedAt: Date
	let author: String
}
