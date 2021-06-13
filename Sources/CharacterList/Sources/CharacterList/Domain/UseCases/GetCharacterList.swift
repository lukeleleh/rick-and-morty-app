import Combine
import Domain

struct GetCharacterList: GetCharacterListUseCase {
    private let dependencies: Dependencies

    init(dependencies: Dependencies = Dependencies()) {
        self.dependencies = dependencies
    }

    func retrieve(requestType: GetCharacterListType) -> AnyPublisher<CharacterListInfo, GetCharacterListError> {
        let publisher: CharacterListPublisher = {
            switch requestType {
            case .homePage:
                return dependencies.repository.retrieve()
            case let .filtered(filters):
                return dependencies.repository.retrieve(filters: filters)
            case let .url(url):
                return dependencies.repository.retrieve(url: url)
            }
        }()

        return publisher
            .map(dependencies.mapper.map(response:))
            .mapError(dependencies.mapper.map(error:))
            .eraseToAnyPublisher()
    }
}

// MARK: - Dependencies

extension GetCharacterList {
    struct Dependencies {
        let repository: CharacterListRepository
        let mapper: CharacterListInfoMapper

        init(
            repository: CharacterListRepository = DefaultCharacterListRepository(),
            mapper: CharacterListInfoMapper = DefaultCharacterListInfoMapper()
        ) {
            self.repository = repository
            self.mapper = mapper
        }
    }
}
