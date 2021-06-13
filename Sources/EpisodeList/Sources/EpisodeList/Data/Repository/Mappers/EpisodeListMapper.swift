import Domain
import struct Foundation.URL

protocol EpisodeListMapper {
    func map(response: EpisodeListResponse) -> EpisodeList
    func map(error: EpisodeListDataSourceError) -> EpisodeListRepositoryError
}

struct DefaultEpisodeListMapper: EpisodeListMapper {
    struct Error: Swift.Error {
        let description: String
    }

    func map(response: EpisodeListResponse) -> EpisodeList {
        let episodes = try? response.results.map { result in
            Episode(
                id: "\(result.id)",
                name: result.name,
                airDate: result.airDate,
                episode: result.episode,
                characterListUrl: try makeCharacterListUrlFrom(urls: result.characters),
                numberOfCaracters: result.characters.count
            )
        }
        let nextUrl = response.info.next ?? ""
        let episodesInfo = EpisodesInfo(paginationURL: try? URL(with: nextUrl))
        let list = EpisodeList(elements: episodes ?? [], info: episodesInfo)
        return list
    }

    func map(error: EpisodeListDataSourceError) -> EpisodeListRepositoryError {
        switch error {
        case .unableToDecode:
            return .unableToDecode
        case let .custom(dataSourceError):
            return .dataSource(dataSourceError)
        }
    }

    private func makeCharacterListUrlFrom(urls: [URL]) throws -> URL {
        guard let baseUrl = urls.first?.deletingLastPathComponent() else {
            throw DefaultEpisodeListMapper.Error(description: "Cannot decode base URL")
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
            throw DefaultEpisodeListMapper.Error(description: "Cannot decode \(type(of: url))")
        }
    }
}
