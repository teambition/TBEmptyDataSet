import XCTest
@testable import TBEmptyDataSet

final class TBEmptyDataSetTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TBEmptyDataSet().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
