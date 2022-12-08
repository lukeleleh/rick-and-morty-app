import Domain
import struct Foundation.URL

struct GetLocationList: GetLocationListUseCase {
    private let dependencies: Dependencies

    init(dependencies: Dependencies = Dependencies()) {
        self.dependencies = dependencies
    }

    func retrieve(requestType: GetLocationListType) async -> Swift.Result<LocationListInfo, GetLocationListError> {
        let repositoryResult: LocationListResult
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

extension GetLocationList {
    struct Dependencies {
        let repository: LocationListRepository
        let mapper: LocationListInfoMapper

        init(
            repository: LocationListRepository = DefaultLocationListRepository(),
            mapper: LocationListInfoMapper = DefaultLocationListInfoMapper()
        ) {
            self.repository = repository
            self.mapper = mapper
        }
    }
}
