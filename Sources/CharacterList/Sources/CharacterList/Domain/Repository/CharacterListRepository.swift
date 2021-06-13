import Combine
import Domain
import struct Foundation.URL

typealias CharacterListPublisher = AnyPublisher<CharacterList, CharacterListRepositoryError>

enum CharacterListRepositoryError: Error {
    case unableToDecode
    case dataSource(Error)
}

protocol CharacterListRepository {
    func retrieve() -> CharacterListPublisher
    func retrieve(url: URL) -> CharacterListPublisher
    func retrieve(filters: Filters) -> CharacterListPublisher
}
