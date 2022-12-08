import Foundation

public struct URLNetworkTargetType: NetworkTargetType {
    public let baseURL: URL
    public let path = ""
    public let method = HTTPMethod.get
    public let task = Task.requestPlain
    public let headers: [String: String]? = nil

    public init(url: URL) {
        baseURL = url
    }
}
