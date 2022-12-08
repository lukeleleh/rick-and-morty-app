import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase(CharacterDetailTests.allTests)
        ]
    }
#endif
