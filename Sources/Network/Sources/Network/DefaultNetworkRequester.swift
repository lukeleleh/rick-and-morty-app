import Combine
import Foundation

struct DefaultNetworkRequester: NetworkRequester {
    private enum HTTPStatusCode {
        static let successfulRange = 200 ..< 300
    }

    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func request(targetType: NetworkTargetType, completion: @escaping Completion) {
        let request = targetType.urlRequest
        let task = session.dataTask(with: request) { data, response, error in
            guard
                error == nil,
                let response = response as? HTTPURLResponse
            else {
                completion(.failure(.error))
                return
            }

            guard HTTPStatusCode.successfulRange ~= response.statusCode else {
                completion(.failure(.error))
                return
            }

            guard let responseData = data else {
                completion(.failure(.error))
                return
            }

            completion(.success(responseData))
        }
        task.resume()
    }

    func request(targetType: NetworkTargetType) -> AnyPublisher<Data, NetworkRequestError> {
        let request = targetType.urlRequest
        return session.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw NetworkRequestError.error
                }

                guard HTTPStatusCode.successfulRange ~= response.statusCode else {
                    throw NetworkRequestError.error
                }

                return output.data
            }
            .mapError { _ in NetworkRequestError.error }
            .eraseToAnyPublisher()
    }
}
