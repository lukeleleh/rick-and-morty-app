import Combine
import Foundation

public enum NetworkRequestError: Error {
    case error
}

public protocol NetworkRequester {
    typealias ResponseResult = Result<Data, NetworkRequestError>
    typealias Completion = (ResponseResult) -> Void

    func request(targetType: NetworkTargetType, completion: @escaping Completion)
    func request(targetType: NetworkTargetType) -> AnyPublisher<Data, NetworkRequestError>
}
