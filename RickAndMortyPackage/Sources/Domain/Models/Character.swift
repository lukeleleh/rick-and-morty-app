import Foundation

public struct Character: Hashable {
    public let id: String
    public let name: String
    public let status: Status
    public let species: String
    public let type: String?
    public let gender: Gender
    public let origin: Location
    public let location: Location
    public let image: URL
    public let episodesUrl: URL
    public let numberOfEpisodes: Int

    public init(
        id: String,
        name: String,
        status: Status,
        species: String,
        type: String?,
        gender: Gender,
        origin: Location,
        location: Location,
        image: URL,
        episodesUrl: URL,
        numberOfEpisodes: Int
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.origin = origin
        self.location = location
        self.image = image
        self.episodesUrl = episodesUrl
        self.numberOfEpisodes = numberOfEpisodes
    }
}

// MARK: - Status

public extension Character {
    enum Status: String, Hashable, CaseIterable {
        case alive, dead, unknown
    }
}

// MARK: - Status

public extension Character {
    enum Gender: String, Hashable, CaseIterable {
        case female, male, genderless, unknown
    }
}

// MARK: - Location

public extension Character {
    enum Location: Hashable {
        case known(name: String, url: String)
        case unknown
    }
}

// MARK: - Mock

public extension Character {
    static let mock = Character(
        id: "1",
        name: "Rick Sánchez",
        status: .alive,
        species: "Species",
        type: "Type",
        gender: .male,
        origin: .known(name: "Earth", url: "Earth"),
        location: .known(name: "Earth 101", url: ""),
        image: .mock,
        episodesUrl: .mock,
        numberOfEpisodes: 6
    )
}
