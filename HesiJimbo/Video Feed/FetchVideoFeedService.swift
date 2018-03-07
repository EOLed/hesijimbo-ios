import PMKFoundation
import PromiseKit
import Foundation
import OpenGraph

typealias VideoFeedListing = (items: [VideoFeedItem], pagination: Pagination)

class FetchVideoFeedService {
	private enum Error: Int {
		case invalidUrl
		case invalidResponse

		static let domain = "com.hesijimbo.FetchVideoFeedService"
	}

	private let session: URLSession
	private let baseUrl = "https://www.reddit.com/r/nba.json"

	init(session: URLSession) {
		self.session = session
	}

	func perform() -> Promise<VideoFeedListing> {
		guard let url = URL(string: baseUrl) else {
			return Promise(error: NSError(
				domain: Error.domain,
				code: Error.invalidUrl.rawValue,
				userInfo: nil
			))
		}

		return session.dataTask(.promise, with: URLRequest(url: url))
			.then { self.toDictionary($0.data) }
			.then { self.toListing($0) }
	}

	private func toDictionary(_ data: Data) -> Promise<[String : AnyObject]> {
		guard let dictionary = try! JSONSerialization.jsonObject(with: data) as? [String : AnyObject] else {
			return Promise(error: NSError(
				domain: Error.domain,
				code: Error.invalidResponse.rawValue,
				userInfo: nil
			))
		}

		return Promise.value(dictionary)
	}

	private func toListing(_ dictionary: [String : AnyObject]) -> Promise<VideoFeedListing> {
		guard let data = dictionary["data"] as? [String : AnyObject],
		let children = data["children"] as? [[String : AnyObject]] else {
			return Promise(error: NSError(
				domain: Error.domain,
				code: Error.invalidResponse.rawValue,
				userInfo: nil
			))
		}

		return Promise.value((buildItems(from: children), buildPagination(from: data)))
	}

	private func buildPagination(from data: [String : AnyObject]) -> Pagination {
		return Pagination.from(
			before: data["before"] as? String,
			after: data["after"] as? String
		)
	}

	private func buildItems(from children: [[String : AnyObject]]) -> [VideoFeedItem] {
		return children
			.filter { hasSecureMedia($0) }
			.flatMap { toVideoFeedItem($0) }
	}

	private func hasSecureMedia(_ dict: [String : AnyObject]) -> Bool {
		guard let data = dict["data"] as? [String : AnyObject] else {
			return false
		}

		return !(data["secure_media"] is NSNull)
	}

	private func toVideoFeedItem(_ dict: [String : AnyObject]) -> VideoFeedItem? {
		guard let data = dict["data"] as? [String : AnyObject],
			let id = data["id"] as? String,
			let title = data["title"] as? String,
			let link = data["url"] as? String,
			let url = URL(string: link),
			let createdAt = data["created_utc"] as? Int,
			let author = data["author"] as? String else {
				return nil
		}

		let og = dataFromOpenGraph(at: url)
		let thumbnail = og.compactMap { $0[.image] }.compactMap { URL(string: $0) }
		let video = og.compactMap { $0[.video] }.compactMap { URL(string: $0) }

		return VideoFeedItem(
			id: id,
			title: title,
			url: url,
			thumbnailUrl: thumbnail,
			videoUrl: video,
			postedAt: Date(timeIntervalSince1970: Double(createdAt)),
			author: author,
			theme: DarkTheme
		)
	}

	private func dataFromOpenGraph(at url: URL) -> Promise<OpenGraph> {
		return Promise<OpenGraph> { seal in
			OpenGraph.fetch(url: url) { og, error in
				if let error = error {
					seal.reject(error)
					return
				}

				if let og = og {
					seal.fulfill(og)
					return
				}
			}
		}
	}
}
