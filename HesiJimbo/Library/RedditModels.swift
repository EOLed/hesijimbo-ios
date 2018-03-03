enum Pagination {
	case beginning(after: String)
	case middle(before: String, after: String)
	case end(before: String)

	static func from(before: String?, after: String?) -> Pagination {
		if let before = before, let after = after {
			return .middle(before: before, after: after)
		}

		if let after = after {
			return .beginning(after: after)
		}

		if let before = before {
			return .end(before: before)
		}

		fatalError("Unexpected error, should have determined a position.")
	}
}
