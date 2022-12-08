import struct Foundation.URL
import Network
import RickAndMortyAPI

enum CharacterListNetworkTargetType: NetworkTargetType {
    case all
    case filter(CharacterListRequestParameters)

    var baseURL: URL { RickAndMortyAPI.baseURL }
    var path: String { "character/" }
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
