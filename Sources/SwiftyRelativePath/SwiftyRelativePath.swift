// MIT licence. Copyright © 2018 Simon Strandgaard. All rights reserved.
import Foundation

extension URL {
	/// SwiftyRelativePath: Creates a path between two paths
	///
	///     let u1 = URL(fileURLWithPath: "/Users/Mozart/Music/Nachtmusik.mp3")!
	///     let u2 = URL(fileURLWithPath: "/Users/Mozart/Documents")!
	///     u1.relativePath(from: u2)  // "../Music/Nachtmusik.mp3"
	///
	/// Case (in)sensitivity is not handled.
	///
	/// It is assumed that given URLs are absolute. Not relative.
	///
	/// This method doesn't access the filesystem. It assumes no symlinks.
	///
	/// `"."` and `".."` in the given URLs are removed.
	///
	/// - Parameter base: The `base` url must be an absolute path to a directory.
	///
	/// - Returns: The returned path is relative to the `base` path.
	///
	public func relativePath(from base: URL) -> String? {
		// Original code written by Martin R. https://stackoverflow.com/a/48360631/78336

		// Ensure that both URLs represent files
		guard self.isFileURL && base.isFileURL else {
			return nil
		}

		// Ensure that it's absolute paths. Ignore relative paths.
		guard self.baseURL == nil && base.baseURL == nil else {
			return nil
		}

		// Remove/replace "." and "..", make paths absolute
		let destComponents = self.standardizedFileURL.pathComponents
		let baseComponents = base.standardizedFileURL.pathComponents

		// Find number of common path components
		var i = 0
		while i < destComponents.count && i < baseComponents.count
			&& destComponents[i] == baseComponents[i] {
				i += 1
		}

		// Build relative path
		var relComponents = Array(repeating: "..", count: baseComponents.count - i)
		relComponents.append(contentsOf: destComponents[i...])
		return relComponents.joined(separator: "/")
	}
}
