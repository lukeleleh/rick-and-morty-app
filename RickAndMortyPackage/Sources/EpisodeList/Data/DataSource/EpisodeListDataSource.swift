import Foundation

typealias EpisodeListDataResult = Result<EpisodeListResponse, EpisodeListDataSourceError>

enum EpisodeListDataSourceError: Error {
    case unableToDecode
    case custom(Error)
}

protocol EpisodeListDataSource {
    func retrieve() async -> EpisodeListDataResult
    func retrieve(url: URL) async -> EpisodeListDataResult
    func retrieve(parameters: EpisodeListRequestParameters) async -> EpisodeListDataResult
}
