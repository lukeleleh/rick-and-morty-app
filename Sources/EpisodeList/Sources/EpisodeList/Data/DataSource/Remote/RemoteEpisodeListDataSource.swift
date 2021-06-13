import Combine
import Foundation
import Network

struct RemoteEpisodeListDataSource: EpisodeListDataSource {
    private let requester: NetworkRequester

    init(requester: NetworkRequester = NetworkRequesterFactory.default) {
        self.requester = requester
    }

    func retrieve() -> AnyPublisher<EpisodeListResponse, EpisodeListDataSourceError> {
        requester.request(targetType: EpisodeListNetworkTargetType.all)
            .mapResponse()
    }

    func retrieve(url: URL) -> AnyPublisher<EpisodeListResponse, EpisodeListDataSourceError> {
        requester.request(targetType: URLNetworkTargetType(url: url))
            .mapResponse()
    }

    func retrieve(parameters: EpisodeListRequestParameters) -> AnyPublisher<EpisodeListResponse, EpisodeListDataSourceError> {
        requester.request(targetType: EpisodeListNetworkTargetType.filter(parameters))
            .mapResponse()
    }
}

private extension AnyPublisher where Output == Data, Failure == NetworkRequestError {
    func mapResponse() -> AnyPublisher<EpisodeListResponse, EpisodeListDataSourceError> {
        tryMap { data in
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(EpisodeListResponse.self, from: data) {
                return response
            } else if let response = try? decoder.decode([EpisodeListResponse.Result].self, from: data) {
                let emptyInfo = EpisodeListResponse.Info(count: response.count, pages: 1, next: nil, prev: nil)
                return EpisodeListResponse(info: emptyInfo, results: response)
            } else if let response = try? decoder.decode(EpisodeListResponse.Result.self, from: data) {
                let emptyInfo = EpisodeListResponse.Info(count: 1, pages: 1, next: nil, prev: nil)
                return EpisodeListResponse(info: emptyInfo, results: [response])
            } else {
                throw EpisodeListDataSourceError.unableToDecode
            }
        }
        .mapError { _ in EpisodeListDataSourceError.unableToDecode }
        .eraseToAnyPublisher()
    }
}
