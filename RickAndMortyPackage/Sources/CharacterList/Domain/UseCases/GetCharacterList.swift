import Domain

struct GetCharacterList: GetCharacterListUseCase {
    private let dependencies: Dependencies

    init(dependencies: Dependencies = Dependencies()) {
        self.dependencies = dependencies
    }

    func retrieve(requestType: GetCharacterListType) async -> Result<CharacterListInfo, GetCharacterListError> {
        let repositoryResult: CharacterListResult
        switch requestType {
        case .homePage:
            repositoryResult = await dependencies.repository.retrieve()
        case let .filtered(filters):
            repositoryResult = await dependencies.repository.retrieve(filters: filters)
        case let .url(url):
            repositoryResult = await dependencies.repository.retrieve(url: url)
        }

        switch repositoryResult {
        case let .success(list):
            return .success(dependencies.mapper.map(response: list))
        case let .failure(error):
            return .failure(dependencies.mapper.map(error: error))
        }
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
