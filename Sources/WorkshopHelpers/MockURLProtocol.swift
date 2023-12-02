import Foundation

public final class MockURLProtocol: URLProtocol {
    private static var response: Result<MockURLResponse, URLError>? = nil
    
    public override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    public override func startLoading() {
        guard let response = MockURLProtocol.response else { return }
        switch response {
        case .success(let successfulResponse):
            client?.urlProtocol(self, didReceive: successfulResponse.urlResponse, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: successfulResponse.data)
            client?.urlProtocolDidFinishLoading(self)
        case .failure(let error):
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    public override func stopLoading() {
        ()
    }

    // MARK: - Mock
    public class func mock(error: URLError) {
        MockURLProtocol.response = .failure(error)
    }
    
    public class func mock<T: Encodable>(responseObject: T, statusCode: Int = 200) {
        let data = try! JSONEncoder().encode(responseObject)
        let httpUrlResponse = HTTPURLResponse(
            url: URL(string: "a_url")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        MockURLProtocol.response = .success(MockURLResponse(urlResponse: httpUrlResponse, data: data))
    }
}

fileprivate struct MockURLResponse {
    let urlResponse: URLResponse
    let data: Data
}
