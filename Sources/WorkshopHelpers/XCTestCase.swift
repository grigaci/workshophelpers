import XCTest

extension XCTestCase {
    
    public func assert<T, E: Error & Equatable>(
        _ expression: @autoclosure () async throws -> T,
        throws error: E,
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        do {
            _ = try await expression()
            XCTFail()
        } catch(let thrownError) {
            XCTAssertTrue(
                thrownError is E,
                "Unexpected error type: \(type(of: thrownError))",
                file: file,
                line: line
            )
            
            XCTAssertEqual(
                error, thrownError as? E,
                file: file,
                line: line
            )
        }
    }
}
