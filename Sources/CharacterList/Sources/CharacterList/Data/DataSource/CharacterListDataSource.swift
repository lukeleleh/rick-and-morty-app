import Combine
import Foundation

enum CharacterListDataSourceError: Error {
    case unableToDecode
    case custom(Error)
}

protocol CharacterListDataSource {
    func retrieve() -> AnyPublisher<CharacterListResponse, CharacterListDataSourceError>
    func retrieve(url: URL) -> AnyPublisher<CharacterListResponse, CharacterListDataSourceError>
    func retrieve(parameters: CharacterListRequestParameters) -> AnyPublisher<CharacterListResponse, CharacterListDataSourceError>
}
