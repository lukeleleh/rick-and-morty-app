import Domain
import struct Foundation.URL

protocol LocationListMapper {
    func map(response: LocationListResponse) -> LocationList
    func map(error: LocationListDataSourceError) -> LocationListRepositoryError
}

struct DefaultLocationListMapper: LocationListMapper {
    struct Error: Swift.Error {
        let description: String
    }

    func map(response: LocationListResponse) -> LocationList {
        let locations = response.results.map { result in
            Location(
                id: "\(result.id)",
                name: result.name,
                type: result.type,
                dimension: result.dimension,
                residentListUrl: makeCharacterListUrlFrom(urls: result.residents),
                numberOfCaracters: result.residents.count
            )
        }
        let nextUrl = response.info.next ?? ""
        let locationsInfo = LocationsInfo(paginationURL: try? URL(with: nextUrl))
        let list = LocationList(elements: locations, info: locationsInfo)
        return list
    }

    func map(error: LocationListDataSourceError) -> LocationListRepositoryError {
        switch error {
        case .unableToDecode:
            return .unableToDecode
        case let .custom(dataSourceError):
            return .dataSource(dataSourceError)
        }
    }

    private func makeCharacterListUrlFrom(urls: [URL]) -> URL? {
        guard let baseUrl = urls.first?.deletingLastPathComponent() else {
            return nil
        }
        let joinedpPathComponents = urls.map { $0.lastPathComponent }.joined(separator: ",")
        return baseUrl.appendingPathComponent(joinedpPathComponents)
    }
}

private extension URL {
    init(with url: String) throws {
        if let url = URL(string: url) {
            self = url
        } else {
            throw DefaultLocationListMapper.Error(description: "Cannot decode \(type(of: url))")
        }
    }
}
