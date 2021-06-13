import Combine
import Domain
import struct Foundation.URL

struct DefaultEpisodeListRepository: EpisodeListRepository {
    private let remoteDataSource: EpisodeListDataSource
    private let mapper: EpisodeListMapper

    init(
        remoteDataSource: EpisodeListDataSource = RemoteEpisodeListDataSource(),
        mapper: EpisodeListMapper = DefaultEpisodeListMapper()
    ) {
        self.remoteDataSource = remoteDataSource
        self.mapper = mapper
    }

    func retrieve() -> AnyPublisher<EpisodeList, EpisodeListRepositoryError> {
        remoteDataSource.retrieve()
            .mapResponse(mapper: mapper)
    }

    func retrieve(url: URL) -> AnyPublisher<EpisodeList, EpisodeListRepositoryError> {
        remoteDataSource.retrieve(url: url)
            .mapResponse(mapper: mapper)
    }
}

private extension AnyPublisher where Output == EpisodeListResponse, Failure == EpisodeListDataSourceError {
    func mapResponse(mapper: EpisodeListMapper) -> AnyPublisher<EpisodeList, EpisodeListRepositoryError> {
        map(mapper.map(response:))
            .mapError(mapper.map(error:))
            .eraseToAnyPublisher()
    }
}
