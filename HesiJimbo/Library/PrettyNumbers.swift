import Foundation

class PrettyNumbers {
	let dateProvider: DateProvider

	init(dateProvider: DateProvider = DateProviderImpl()) {
		self.dateProvider = dateProvider
	}

	func commentCount(_ count: Int) -> String {
		if count > 10000 {
			return String(format: "%gK", roundTo(places: 1, value: Double(count) / 1000.0))
		}

		return "\(count)"
	}

	func voteCount(_ count: Int) -> String {
		return commentCount(count)
	}

	func timeAgo(epochUtc: Int) -> String {
		let currentEpochUtc = Int(dateProvider.get().timeIntervalSince1970)
		let timeDifferenceInSeconds = currentEpochUtc - epochUtc

		switch timeDifferenceInSeconds {
		case Int.min..<0:
			return "0s"
		case 0..<60:
			return timeInSeconds(seconds: timeDifferenceInSeconds)
		case 60..<(60 * 60):
			return timeInMinutes(seconds: timeDifferenceInSeconds)
		case (60 * 60)..<(60 * 60 * 24):
			return timeInHours(seconds: timeDifferenceInSeconds)
		case (60 * 60 * 24)..<(60 * 60 * 24 * 7):
			return timeInDays(seconds: timeDifferenceInSeconds)
		case (60 * 60 * 24 * 7)..<(60 * 60 * 24 * 31):
			return timeInWeeks(seconds: timeDifferenceInSeconds)
		case (60 * 60 * 24 * 31)..<(60 * 60 * 24 * 365):
			return timeAgoInMonths(seconds: timeDifferenceInSeconds)
		default:
			return timeAgoInYears(seconds: timeDifferenceInSeconds)
		}
	}

	private func timeInSeconds(seconds: Int) -> String {
		return "\(seconds)s"
	}

	private func timeInMinutes(seconds: Int) -> String {
		return "\(seconds / 60)m"
	}

	private func timeInHours(seconds: Int) -> String {
		return "\(Int(Double(seconds) / 60.0 / 60.0))h"
	}

	private func timeInDays(seconds: Int) -> String {
		return "\(Int(Double(seconds) / 60.0 / 60.0 / 24.0))d"
	}

	private func timeInWeeks(seconds: Int) -> String {
		return "\(Int(Double(seconds) / 60.0 / 60.0 / 24.0 / 7.0))w"
	}

	private func timeAgoInMonths(seconds: Int) -> String {
		return "\(Int(Double(seconds) / 60.0 / 60.0 / 24.0 / 31.0))m"
	}

	private func timeAgoInYears(seconds: Int) -> String {
		return "\(Int(Double(seconds) / 60.0 / 60.0 / 24.0 / 365.0))y"
	}

	private func roundTo(places:Int, value: Double) -> Double {
		let divisor = pow(10.0, Double(places))
		return floor(value * divisor) / divisor
	}
}
