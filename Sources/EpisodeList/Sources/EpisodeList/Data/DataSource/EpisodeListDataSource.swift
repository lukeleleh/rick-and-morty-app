import Combine
import Foundation

enum EpisodeListDataSourceError: Error {
    case unableToDecode
    case custom(Error)
}

protocol EpisodeListDataSource {
    func retrieve() -> AnyPublisher<EpisodeListResponse, EpisodeListDataSourceError>
    func retrieve(url: URL) -> AnyPublisher<EpisodeListResponse, EpisodeListDataSourceError>
    func retrieve(parameters: EpisodeListRequestParameters) -> AnyPublisher<EpisodeListResponse, EpisodeListDataSourceError>
}
