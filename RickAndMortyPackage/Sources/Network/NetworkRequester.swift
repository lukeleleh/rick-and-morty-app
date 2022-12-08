import Foundation

public enum NetworkRequestError: Error {
    case error
}

public protocol NetworkRequester {
    func request(targetType: NetworkTargetType) async throws -> Data
}
