import Combine
import Domain

struct GetEpisodeList: GetEpisodeListUseCase {
    private let dependencies: Dependencies

    init(dependencies: Dependencies = Dependencies()) {
        self.dependencies = dependencies
    }

    func retrieve(requestType: GetEpisodeListType) -> AnyPublisher<EpisodeListInfo, GetEpisodeListError> {
        let publisher: AnyPublisher<EpisodeList, EpisodeListRepositoryError> = {
            switch requestType {
            case .homePage:
                return dependencies.repository.retrieve()
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
