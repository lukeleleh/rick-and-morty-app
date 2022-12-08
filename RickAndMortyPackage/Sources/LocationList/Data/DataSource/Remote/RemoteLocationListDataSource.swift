import Combine
import Foundation
import Network

struct RemoteLocationListDataSource: LocationListDataSource {
    private let requester: NetworkRequester

    init(requester: NetworkRequester = NetworkRequesterFactory.default) {
        self.requester = requester
    }

    func retrieve() -> AnyPublisher<LocationListResponse, LocationListDataSourceError> {
        requester.request(targetType: LocationListNetworkTargetType.all)
            .mapResponse()
    }

    func retrieve(url: URL) -> AnyPublisher<LocationListResponse, LocationListDataSourceError> {
        requester.request(targetType: URLNetworkTargetType(url: url))
            .mapResponse()
    }

    func retrieve(parameters: LocationListRequestParameters) -> AnyPublisher<LocationListResponse, LocationListDataSourceError> {
        requester.request(targetType: LocationListNetworkTargetType.filter(parameters))
            .mapResponse()
    }
}

private extension AnyPublisher where Output == Data, Failure == NetworkRequestError {
    func mapResponse() -> AnyPublisher<LocationListResponse, LocationListDataSourceError> {
        mapError(LocationListDataSourceError.custom)
            .decode(type: LocationListResponse.self, decoder: JSONDecoder())
            .mapError { _ in LocationListDataSourceError.unableToDecode }
            .eraseToAnyPublisher()
    }
}
