import Combine
import Domain
import struct Foundation.URL

struct DefaultCharacterListRepository: CharacterListRepository {
    private let dependencies: Dependencies

    init(dependencies: Dependencies = Dependencies()) {
        self.dependencies = dependencies
    }

    func retrieve() -> CharacterListPublisher {
        dependencies.remoteDataSource.retrieve()
            .mapResponse(mapper: dependencies.mapper)
    }

    func retrieve(url: URL) -> CharacterListPublisher {
        dependencies.remoteDataSource.retrieve(url: url)
            .mapResponse(mapper: dependencies.mapper)
    }

    func retrieve(filters: Filters) -> CharacterListPublisher {
        dependencies.remoteDataSource.retrieve(parameters: CharacterListRequestParameters(filters: filters))
            .mapResponse(mapper: dependencies.mapper)
    }
}

// MARK: - Dependencies

extension DefaultCharacterListRepository {
    struct Dependencies {
        let remoteDataSource: CharacterListDataSource
        let mapper: CharacterListMapper

        init(
            remoteDataSource: CharacterListDataSource = RemoteCharacterListDataSource(),
            mapper: CharacterListMapper = DefaultCharacterListMapper()
        ) {
            self.remoteDataSource = remoteDataSource
            self.mapper = mapper
        }
    }
}

// MARK: - CharacterListRequestParameters+Filters

private extension CharacterListRequestParameters {
    init(filters: Filters) {
        self.status = filters.status?.rawValue
        self.gender = filters.gender?.rawValue
    }
}

private extension AnyPublisher where Output == CharacterListResponse, Failure == CharacterListDataSourceError {
    func mapResponse(mapper: CharacterListMapper) -> CharacterListPublisher {
        map(mapper.map(response:))
            .mapError(mapper.map(error:))
            .eraseToAnyPublisher()
    }
}
