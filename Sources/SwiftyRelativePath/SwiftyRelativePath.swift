// MIT licence. Copyright © 2018 Simon Strandgaard. All rights reserved.
import Foundation

extension URL {
	/// "." and ".." in the given URLs are removed, and relative file URLs are made absolute (both using the standardized method of URL).
	///
	/// Case (in)sensitivity is not handled.
	///
	/// It is assumed that the base URL represents a directory.
	public func relativePath(from base: URL) -> String? {
		// Original code written by Martin R. https://stackoverflow.com/a/48360631/78336

		// Ensure that both URLs represent files:
		guard self.isFileURL && base.isFileURL else {
			return nil
		}

		// Remove/replace "." and "..", make paths absolute:
		let destComponents = self.standardizedFileURL.pathComponents
		let baseComponents = base.standardizedFileURL.pathComponents

		// Find number of common path components:
		var i = 0
		while i < destComponents.count && i < baseComponents.count
			&& destComponents[i] == baseComponents[i] {
				i += 1
		}

		// Build relative path:
		var relComponents = Array(repeating: "..", count: baseComponents.count - i)
		relComponents.append(contentsOf: destComponents[i...])
		return relComponents.joined(separator: "/")
	}
}
