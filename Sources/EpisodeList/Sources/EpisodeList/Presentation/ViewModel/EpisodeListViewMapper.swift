import Domain

protocol EpisodeListViewMapper {
    func map(from listInfo: EpisodeListInfo, shouldReload: Bool) -> EpisodeListPresentation
    func map(from error: GetEpisodeListError) -> EpisodeListError
}

struct DefaultEpisodeListViewMapper: EpisodeListViewMapper {
    func map(from listInfo: EpisodeListInfo, shouldReload _: Bool) -> EpisodeListPresentation {
        let episodes = listInfo.episodes.map {
            EpisodePresentation(
                title: "\($0.episode) · \($0.name)",
                airDate: $0.airDate,
                model: $0
            )
        }
        let episodeListPresentation = EpisodeListPresentation.data(
            episodes: episodes,
            hasMore: listInfo.areMoreAvailable
        )
        return episodeListPresentation
    }

    func map(from error: GetEpisodeListError) -> EpisodeListError {
        switch error {
        case .unableToGetList:
            return EpisodeListError(
                title: "Oh, geez Rick!",
                description: "There are no episodes to show right now."
            )
        }
    }
}
