// MIT licence. Copyright © 2018 Simon Strandgaard. All rights reserved.
import XCTest
@testable import SwiftyRelativePath

class SwiftyRelativePathTests: XCTestCase {
	func process(_ p1: String, _ p2: String) -> String? {
		let u1 = URL(fileURLWithPath: p1)
		let u2 = URL(fileURLWithPath: p2)
		return u1.relativePath(from: u2)
	}

	func processUrl(_ p1: String, _ p2: String) -> String? {
		let u1 = URL(string: p1)!
		let u2 = URL(string: p2)!
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
		XCTAssertEqual(processUrl("file:///evil%2Fsecret.pdf", "file:///evil"), "secret.pdf")
		XCTAssertEqual(processUrl("file:///asd/conspiracy/triton/climateforecast.pdf", "file:///asd%2Fconspiracy%2Ffairlight"), "../triton/climateforecast.pdf")
		XCTAssertEqual(processUrl("file:///a/b/%2E%2E/c/haujobb", "file:///a/d"), "../c/haujobb")
		XCTAssertEqual(processUrl("file://localhost/demos/kefrens.zip", "file:///demos"), "kefrens.zip")
	}

	func testEmpty() {
		XCTAssertEqual(process("/", "/"), "")
		XCTAssertEqual(process("/./././root", "/root/../root"), "")
		XCTAssertEqual(process("/./././root/./.", "/root"), "")
		XCTAssertEqual(processUrl("file:///dir", "file:///dir"), "")
	}

	func testInvalid() {
		do {
			// Both urls must be file://
			XCTAssertNil(processUrl("file:///dir", "https://localhost/dir"))
			XCTAssertNil(processUrl("https://localhost/dir", "file:///dir"))
			XCTAssertNil(processUrl("https://localhost/dir", "https://localhost"))
		}
		do {
			// Compose a dangerous path that tries to break out of the rootdir
			let u1 = URL(string: "../../../voynich-manuscript.rtf", relativeTo: URL(string: "file:///books")!)!
			let u2 = URL(string: "file:///")!
			XCTAssertNil(u1.relativePath(from: u2))
		}
	}

    static var allTests = [
		("testNormal", testNormal),
		("testEmpty", testEmpty),
		("testInvalid", testInvalid),
    ]
}
