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

    func retrieve() async -> LocationListResult {
        let remoteDataSourceResult = await remoteDataSource.retrieve()
        return mapResponse(from: remoteDataSourceResult)
    }

    func retrieve(url: URL) async -> LocationListResult {
        let remoteDataSourceResult = await remoteDataSource.retrieve(url: url)
        return mapResponse(from: remoteDataSourceResult)
    }
}

private extension DefaultLocationListRepository {
    func mapResponse(from result: LocationListDataResult) -> LocationListResult {
        switch result {
        case let .success(response):
            return .success(mapper.map(response: response))
        case let .failure(error):
            return .failure(mapper.map(error: error))
        }
    }
}
