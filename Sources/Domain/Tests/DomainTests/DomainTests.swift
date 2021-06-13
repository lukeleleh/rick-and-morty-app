@testable import Domain
import XCTest

final class DomainTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Domain().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample)
    ]
}
