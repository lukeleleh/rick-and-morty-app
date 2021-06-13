import Domain
import struct Foundation.URL

protocol CharacterListMapper {
    func map(response: CharacterListResponse) -> CharacterList
    func map(error: CharacterListDataSourceError) -> CharacterListRepositoryError
}

struct DefaultCharacterListMapper: CharacterListMapper {
    struct Error: Swift.Error {
        let description: String
    }

    func map(response: CharacterListResponse) -> CharacterList {
        let characters = try? response.results.compactMap { result -> Character in
            let characterEpisodes = result.episode.compactMap(URL.init(string:))
            guard let episodePath = characterEpisodes.first?.deletingLastPathComponent() else {
                throw Error(description: "There will be always one episode or more")
            }
            let episodesPathComponents = characterEpisodes.map(\.lastPathComponent).joined(separator: ",")
            let episodesUrl = episodePath
                .appendingPathComponent(episodesPathComponents)
            return Character(
                id: "\(result.id)",
                name: result.name,
                status: try .init(status: result.status),
                species: result.species,
                type: result.type.isEmpty ? nil : result.type,
                gender: try .init(gender: result.gender),
                origin: try .init(location: result.origin),
                location: try .init(location: result.location),
                image: try .init(with: result.image),
                episodesUrl: episodesUrl,
                numberOfEpisodes: result.episode.count
            )
        }
        let nextUrl = response.info.next ?? ""
        let charactersInfo = CharactersInfo(paginationURL: try? URL(with: nextUrl))
        let list = CharacterList(elements: characters ?? [], info: charactersInfo)
        return list
    }

    func map(error: CharacterListDataSourceError) -> CharacterListRepositoryError {
        switch error {
        case .unableToDecode:
            return .unableToDecode
        case let .custom(dataSourceError):
            return .dataSource(dataSourceError)
        }
    }
}

private extension Character.Status {
    init(status: CharacterListResponse.Result.Status) throws {
        if let status = Character.Status(rawValue: status.rawValue.lowercased()) {
            self = status
        } else {
            throw DefaultCharacterListMapper.Error(description: "Cannot decode \(type(of: status))")
        }
    }
}

private extension Character.Gender {
    init(gender: CharacterListResponse.Result.Gender) throws {
        if let gender = Character.Gender(rawValue: gender.rawValue.lowercased()) {
            self = gender
        } else {
            throw DefaultCharacterListMapper.Error(description: "Cannot decode \(type(of: gender))")
        }
    }
}

private extension Character.Location {
    init(location: CharacterListResponse.Result.Location) throws {
        if !location.name.isEmpty {
            if !location.url.isEmpty {
                self = .known(name: location.name, url: location.url)
            } else {
                self = .unknown
            }
        } else {
            throw DefaultCharacterListMapper.Error(description: "Cannot decode \(type(of: location))")
        }
    }
}

private extension URL {
    init(with url: String) throws {
        if let url = URL(string: url) {
            self = url
        } else {
            throw DefaultCharacterListMapper.Error(description: "Cannot decode \(type(of: url))")
        }
    }
}
