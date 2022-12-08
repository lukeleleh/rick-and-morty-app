import Combine
import Foundation

enum LocationListDataSourceError: Error {
    case unableToDecode
    case custom(Error)
}

protocol LocationListDataSource {
    func retrieve() -> AnyPublisher<LocationListResponse, LocationListDataSourceError>
    func retrieve(url: URL) -> AnyPublisher<LocationListResponse, LocationListDataSourceError>
    func retrieve(parameters: LocationListRequestParameters) -> AnyPublisher<LocationListResponse, LocationListDataSourceError>
}
