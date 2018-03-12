import UIKit

struct Theme {
	let backgroundColor: UIColor
	let viewBackgroundColor: UIColor
	let bodyColor: UIColor
	let accentColor: UIColor
	let statusBarStyle: UIStatusBarStyle

	static let dark = Theme(
		backgroundColor: .black,
		viewBackgroundColor: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0),
		bodyColor: UIColor(white: 0.95, alpha: 1.0),
		accentColor: UIColor(red: 1, green: 0.54, blue: 0.24, alpha: 1.0),
		statusBarStyle: .lightContent
	)
}
