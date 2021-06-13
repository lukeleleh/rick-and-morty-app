import Foundation

public struct Episode: Hashable {
    public let id: String
    public let name: String
    public let airDate: String
    public let episode: String
    public let characterListUrl: URL
    public let numberOfCaracters: Int

    public init(id: String, name: String, airDate: String, episode: String, characterListUrl: URL, numberOfCaracters: Int) {
        self.id = id
        self.name = name
        self.airDate = airDate
        self.episode = episode
        self.characterListUrl = characterListUrl
        self.numberOfCaracters = numberOfCaracters
    }
}

public extension Episode {
    static let mock = Episode(
        id: "1",
        name: "Pilot",
        airDate: "December 2, 2013",
        episode: "S01E01",
        characterListUrl: .mock,
        numberOfCaracters: 8
    )
}
