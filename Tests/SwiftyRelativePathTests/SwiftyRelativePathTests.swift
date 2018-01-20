// MIT licence. Copyright © 2018 Simon Strandgaard. All rights reserved.
import XCTest
@testable import SwiftyRelativePath

class SwiftyRelativePathTests: XCTestCase {
	func process(_ p1: String, _ p2: String) -> String? {
		let u1 = URL(fileURLWithPath: p1)
		let u2 = URL(fileURLWithPath: p2)
		return u1.relativePath(from: u2)
	}

	func testNormal() {
		XCTAssertEqual(process("/usr/X11/agent/47.gz", "/usr/X11"), "agent/47.gz")
		XCTAssertEqual(process("/usr/share/man/meltdown.1", "/usr/share/cups"), "../man/meltdown.1")
		XCTAssertEqual(process("/var/logs/x/y/z/log.txt", "/var/logs"), "x/y/z/log.txt")
		XCTAssertEqual(process("/tmp/president.sock", "/"), "tmp/president.sock")
		XCTAssertEqual(process("/Users/johndoe/../janedoe/.Trash/bitcoin.wallet", "/Users/janedoe"), ".Trash/bitcoin.wallet")
		XCTAssertEqual(process("/server/farbrausch/demo.exe", "/server/loonies"), "../farbrausch/demo.exe")
		XCTAssertEqual(process("/home/martinr/backup2019.tgz", "/home/martinr"), "backup2019.tgz")
		XCTAssertEqual(process("/proc/x/y", "/proc/x/y/a"), "..")
		XCTAssertEqual(process("/proc/x/y", "/proc/x/y/a/b/c"), "../../..")
		XCTAssertEqual(process("/proc/x/y/z/w/gpu", "/proc/x/y/a/b/c"), "../../../z/w/gpu")
		XCTAssertEqual(process("/admin/.profile", "/admin"), ".profile")
		XCTAssertEqual(process("/.../...", "/"), ".../...")
	}

	func testEmpty() {
		XCTAssertEqual(process("", ""), "")
		XCTAssertEqual(process("/./././root", "/root/../root"), "")
		XCTAssertEqual(process("/./././root/./.", "/root"), "")
	}

	func testInvalid() {
//		XCTAssertNil(process("/../../boom.txt", "/"))
//		XCTAssertNil(process("/var/../../boom.txt", "/var/logs"))
//		XCTAssertNil(process("/../../boom.txt", "/var/logs"))
	}

    static var allTests = [
        ("testNormal", testNormal),
		("testEmpty", testEmpty),
		("testInvalid", testInvalid),
    ]
}
