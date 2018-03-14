func nonFatalError(_ message: String) {
	#if DEBUG
		fatalError(message)
	#else
		print("[ERROR] \(message)")
	#endif
}

func log(_ message: String) {
	#if DEBUG
		print("[DEBUG] \(message)")
	#endif
}
