import PromiseKit
import UIKit

protocol FetchTeamLogoService {
	func perform(url: String) -> Promise<UIImage>
}

class FetchTeamLogoServiceImpl: FetchTeamLogoService {
	enum Error: Int {
		case invalidUrl
		case badImage

		static let domain = "com.hesijimbo.FetchTeamLogoServiceImpl"
	}

	private let session: URLSession

	init(session: URLSession) {
		self.session = session
	}

	func perform(url: String) -> Promise<UIImage> {
		guard let url = URL(string: url) else {
			return Promise(error: NSError(
				domain: Error.domain,
				code: Error.invalidUrl.rawValue,
				userInfo: nil
			))
		}

		return session.dataTask(.promise, with: URLRequest(url: url))
			.then { (data, response) -> Promise<UIImage> in
				guard let image = UIImage(data: data) else {
					return Promise(error: NSError(
						domain: Error.domain,
						code: Error.badImage.rawValue,
						userInfo: nil
					))
				}

				return Promise<UIImage>.value(image)
		}
	}
}
