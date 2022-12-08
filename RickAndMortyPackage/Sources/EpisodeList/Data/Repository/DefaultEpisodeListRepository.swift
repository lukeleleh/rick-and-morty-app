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

    func retrieve() async -> EpisodeListResult {
        let remoteDataSourceResult = await remoteDataSource.retrieve()
        return mapResponse(from: remoteDataSourceResult)
    }

    func retrieve(url: URL) async -> EpisodeListResult {
        let remoteDataSourceResult = await remoteDataSource.retrieve(url: url)
        return mapResponse(from: remoteDataSourceResult)
    }
}

private extension DefaultEpisodeListRepository {
    func mapResponse(from result: EpisodeListDataResult) -> EpisodeListResult {
        switch result {
        case let .success(response):
            return .success(mapper.map(response: response))
        case let .failure(error):
            return .failure(mapper.map(error: error))
        }
    }
}
