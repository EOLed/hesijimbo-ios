import Foundation

protocol DateProvider {
	func get() -> Date
}

class DateProviderImpl: DateProvider {
	func get() -> Date {
		return Date()
	}
}
