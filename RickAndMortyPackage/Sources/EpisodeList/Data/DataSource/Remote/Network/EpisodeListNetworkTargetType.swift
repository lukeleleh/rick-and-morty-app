import struct Foundation.URL
import Network
import RickAndMortyAPI

enum EpisodeListNetworkTargetType: NetworkTargetType {
    case all
    case filter(EpisodeListRequestParameters)

    var baseURL: URL { RickAndMortyAPI.baseURL }
    var path: String { "episode/" }
    var method: HTTPMethod { .get }
    var task: Task {
        switch self {
        case .all:
            return .requestPlain
        case let .filter(parameters):
            return .request(parameters: parameters)
        }
    }

    var headers: [String: String]? { nil }
}
