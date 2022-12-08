import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase(CharacterListTests.allTests)
        ]
    }
#endif
