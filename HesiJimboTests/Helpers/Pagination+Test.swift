@testable import HesiJimbo

extension Pagination {
	var before: String! {
		switch self {
		case .middle(before: let before, after: _):
			return before
		case .end(before: let before):
			return before
		case .beginning(let after):
			return nil
		}
	}

	var after: String! {
		switch self {
		case .beginning(after: let after):
			return after
		case .middle(before: _, after: let after):
			return after
		case .end(_):
			return nil
		}
	}
}
