import Domain

struct GetEpisodeList: GetEpisodeListUseCase {
    private let dependencies: Dependencies

    init(dependencies: Dependencies = Dependencies()) {
        self.dependencies = dependencies
    }

    func retrieve(requestType: GetEpisodeListType) async -> Result<EpisodeListInfo, GetEpisodeListError> {
        let repositoryResult: EpisodeListResult
        switch requestType {
        case .homePage:
            repositoryResult = await dependencies.repository.retrieve()
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

extension GetEpisodeList {
    struct Dependencies {
        let repository: EpisodeListRepository
        let mapper: EpisodeListInfoMapper

        init(
            repository: EpisodeListRepository = DefaultEpisodeListRepository(),
            mapper: EpisodeListInfoMapper = DefaultEpisodeListInfoMapper()
        ) {
            self.repository = repository
            self.mapper = mapper
        }
    }
}
