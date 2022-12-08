import Combine
import struct Foundation.URL

public enum GetCharacterListError: Error {
    case unableToGetList
}

public enum GetCharacterListType: Equatable {
    case homePage
    case filtered(Filters)
    case url(URL)
}

public protocol GetCharacterListUseCase {
    func retrieve(requestType: GetCharacterListType) -> AnyPublisher<CharacterListInfo, GetCharacterListError>
}
