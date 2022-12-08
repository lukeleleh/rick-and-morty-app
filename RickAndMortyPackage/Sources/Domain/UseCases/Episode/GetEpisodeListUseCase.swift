import struct Foundation.URL

public enum GetEpisodeListError: Error {
    case unableToGetList
}

public enum GetEpisodeListType {
    case homePage
    case url(URL)
}

public protocol GetEpisodeListUseCase {
    func retrieve(requestType: GetEpisodeListType) async -> Result<EpisodeListInfo, GetEpisodeListError>
}
