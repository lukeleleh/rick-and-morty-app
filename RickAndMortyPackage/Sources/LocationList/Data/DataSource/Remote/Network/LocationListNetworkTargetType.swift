import struct Foundation.URL
import Network
import RickAndMortyAPI

enum LocationListNetworkTargetType: NetworkTargetType {
    case all
    case filter(LocationListRequestParameters)

    var baseURL: URL { RickAndMortyAPI.baseURL }
    var path: String { "location/" }
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
