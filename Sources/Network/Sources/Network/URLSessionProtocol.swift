import Foundation

protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}
