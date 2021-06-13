import Combine
import Foundation
import Network

struct RemoteCharacterListDataSource: CharacterListDataSource {
    private let requester: NetworkRequester

    init(requester: NetworkRequester = NetworkRequesterFactory.default) {
        self.requester = requester
    }

    func retrieve() -> AnyPublisher<CharacterListResponse, CharacterListDataSourceError> {
        requester.request(targetType: CharacterListNetworkTargetType.all)
            .mapResponse()
    }

    func retrieve(url: URL) -> AnyPublisher<CharacterListResponse, CharacterListDataSourceError> {
        requester.request(targetType: URLNetworkTargetType(url: url))
            .mapResponse()
    }

    func retrieve(parameters: CharacterListRequestParameters) -> AnyPublisher<CharacterListResponse, CharacterListDataSourceError> {
        requester.request(targetType: CharacterListNetworkTargetType.filter(parameters))
            .mapResponse()
    }
}

private extension AnyPublisher where Output == Data, Failure == NetworkRequestError {
    func mapResponse() -> AnyPublisher<CharacterListResponse, CharacterListDataSourceError> {
        tryMap { data in
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(CharacterListResponse.self, from: data) {
                return response
            } else if let response = try? decoder.decode([CharacterListResponse.Result].self, from: data) {
                let emptyInfo = CharacterListResponse.Info(count: response.count, pages: 1, next: nil, prev: nil)
                return CharacterListResponse(info: emptyInfo, results: response)
            } else if let response = try? decoder.decode(CharacterListResponse.Result.self, from: data) {
                let emptyInfo = CharacterListResponse.Info(count: 1, pages: 1, next: nil, prev: nil)
                return CharacterListResponse(info: emptyInfo, results: [response])
            } else {
                throw CharacterListDataSourceError.unableToDecode
            }
        }
        .mapError { _ in CharacterListDataSourceError.unableToDecode }
        .eraseToAnyPublisher()
    }
}
