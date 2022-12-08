import Combine
import struct Foundation.URL

struct DefaultLocationListRepository: LocationListRepository {
    private let remoteDataSource: LocationListDataSource
    private let mapper: LocationListMapper

    init(
        remoteDataSource: LocationListDataSource = RemoteLocationListDataSource(),
        mapper: LocationListMapper = DefaultLocationListMapper()
    ) {
        self.remoteDataSource = remoteDataSource
        self.mapper = mapper
    }

    func retrieve() -> AnyPublisher<LocationList, LocationListRepositoryError> {
        remoteDataSource.retrieve()
            .mapResponse(mapper: mapper)
    }

    func retrieve(url: URL) -> AnyPublisher<LocationList, LocationListRepositoryError> {
        remoteDataSource.retrieve(url: url)
            .mapResponse(mapper: mapper)
    }
}

private extension AnyPublisher where Output == LocationListResponse, Failure == LocationListDataSourceError {
    func mapResponse(mapper: LocationListMapper) -> AnyPublisher<LocationList, LocationListRepositoryError> {
        map(mapper.map(response:))
            .mapError(mapper.map(error:))
            .eraseToAnyPublisher()
    }
}
