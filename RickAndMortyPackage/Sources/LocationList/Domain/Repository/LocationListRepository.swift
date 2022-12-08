import Combine
import struct Foundation.URL

enum LocationListRepositoryError: Error {
    case unableToDecode
    case dataSource(Error)
}

protocol LocationListRepository {
    func retrieve() -> AnyPublisher<LocationList, LocationListRepositoryError>
    func retrieve(url: URL) -> AnyPublisher<LocationList, LocationListRepositoryError>
}
