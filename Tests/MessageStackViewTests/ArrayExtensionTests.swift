import XCTest
@testable import MessageStackView

final class ArrayExtensionTests: XCTestCase {

    /// Default test elements
    private let items = ["A", "B", "C", "D", "E"]

    /// Single test element
    private let single = [17]

    /// Double test element
    private let double = [345, 92]

    // MARK: - Tests

    func testElementAfter() {
        XCTAssertEqual(items.elementAfterFirst(of: "A"), "B")
        XCTAssertEqual(items.elementAfterFirst(of: "B"), "C")
        XCTAssertEqual(items.elementAfterFirst(of: "C"), "D")
        XCTAssertEqual(items.elementAfterFirst(of: "D"), "E")
        XCTAssertNil(items.elementAfterFirst(of: "E"))

        XCTAssertNil(items.elementAfterFirst(of: UUID().uuidString))
    }

    func testElementBefore() {
        XCTAssertNil(items.elementBeforeFirst(of: "A"))
        XCTAssertEqual(items.elementBeforeFirst(of: "B"), "A")
        XCTAssertEqual(items.elementBeforeFirst(of: "C"), "B")
        XCTAssertEqual(items.elementBeforeFirst(of: "D"), "C")
        XCTAssertEqual(items.elementBeforeFirst(of: "E"), "D")

        XCTAssertNil(items.elementBeforeFirst(of: UUID().uuidString))
    }

    func testEmpty() {
        let empty: [String] = []

        ["", "x"].forEach {
            XCTAssertNil(empty.elementBeforeFirst(of: $0))
            XCTAssertNil(empty.elementAfterFirst(of: $0))
        }
    }

    func testSingle() {
        guard let element = single.first else {
            XCTFail("\(#function) array invalid")
            return
        }

        XCTAssertNil(single.elementBeforeFirst(of: element))
        XCTAssertNil(single.elementAfterFirst(of: element))
    }

    func testDouble() {
        guard let first = double.first, let last = double.last else {
            XCTFail("\(#function) array invalid")
            return
        }

        XCTAssertNil(double.elementBeforeFirst(of: first))
        XCTAssertEqual(double.elementAfterFirst(of: first), last)

        XCTAssertEqual(double.elementBeforeFirst(of: last), first)
        XCTAssertNil(double.elementAfterFirst(of: last))
    }

    static var allTests = [
        ("testElementAfter", testElementAfter),
        ("testElementBefore", testElementBefore),
        ("testEmpty", testEmpty),
        ("testSingle", testSingle),
        ("testDouble", testDouble)
    ]
}
