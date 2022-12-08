import Domain

protocol EpisodeListInfoMapper {
    func map(response: EpisodeList) -> EpisodeListInfo
    func map(error: EpisodeListRepositoryError) -> GetEpisodeListError
}

struct DefaultEpisodeListInfoMapper: EpisodeListInfoMapper {
    func map(response: EpisodeList) -> EpisodeListInfo {
        EpisodeListInfo(
            episodes: response.elements,
            nextPageRequest: response.info.paginationURL.map(GetEpisodeListType.url)
        )
    }

    func map(error _: EpisodeListRepositoryError) -> GetEpisodeListError {
        .unableToGetList
    }
}
