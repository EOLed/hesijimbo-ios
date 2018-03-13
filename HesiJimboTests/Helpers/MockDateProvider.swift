import Foundation

@testable import HesiJimbo

class MockDateProvider: DateProvider {
	var now: Date

	init(now: Date) {
		self.now = now
	}

	func get() -> Date {
		return now
	}
}
