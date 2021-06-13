@testable import SwiftUtils
import XCTest

final class SwiftUtilsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftUtils().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample)
    ]
}
