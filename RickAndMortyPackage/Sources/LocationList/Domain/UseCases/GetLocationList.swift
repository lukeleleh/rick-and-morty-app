import Combine
import Domain
import struct Foundation.URL

struct GetLocationList: GetLocationListUseCase {
    private let dependencies: Dependencies

    init(dependencies: Dependencies = Dependencies()) {
        self.dependencies = dependencies
    }

    func retrieve(requestType: GetLocationListType) -> AnyPublisher<LocationListInfo, GetLocationListError> {
        let publisher: AnyPublisher<LocationList, LocationListRepositoryError> = {
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
