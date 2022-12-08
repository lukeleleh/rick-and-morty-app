import Domain
import struct Foundation.URL

typealias CharacterListResult = Result<CharacterList, CharacterListRepositoryError>

enum CharacterListRepositoryError: Error {
    case unableToDecode
    case dataSource(Error)
}

protocol CharacterListRepository {
    func retrieve() async -> CharacterListResult
    func retrieve(url: URL) async -> CharacterListResult
    func retrieve(filters: Filters) async -> CharacterListResult
}
