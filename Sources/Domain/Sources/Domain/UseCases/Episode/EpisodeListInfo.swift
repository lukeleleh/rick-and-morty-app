public struct EpisodeListInfo {
    public let episodes: [Episode]
    public let nextPageRequest: GetEpisodeListType?

    public init(episodes: [Episode], nextPageRequest: GetEpisodeListType?) {
        self.episodes = episodes
        self.nextPageRequest = nextPageRequest
    }
}

public extension EpisodeListInfo {
    var areMoreAvailable: Bool {
        nextPageRequest != nil
    }
}
