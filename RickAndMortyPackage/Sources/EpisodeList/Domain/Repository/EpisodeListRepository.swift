import Combine
import Domain
import struct Foundation.URL

enum EpisodeListRepositoryError: Error {
    case unableToDecode
    case dataSource(Error)
}

protocol EpisodeListRepository {
    func retrieve() -> AnyPublisher<EpisodeList, EpisodeListRepositoryError>
    func retrieve(url: URL) -> AnyPublisher<EpisodeList, EpisodeListRepositoryError>
}
