import Foundation
import Network

struct RemoteLocationListDataSource: LocationListDataSource {
    private let requester: NetworkRequester

    init(requester: NetworkRequester = NetworkRequesterFactory.default) {
        self.requester = requester
    }

    func retrieve() async -> LocationListDataResult {
        do {
            let data = try await requester.request(targetType: LocationListNetworkTargetType.all)
            return mapResponse(from: data)
        } catch {
            return .failure(.custom(error))
        }
    }

    func retrieve(url: URL) async -> LocationListDataResult {
        do {
            let data = try await requester.request(targetType: URLNetworkTargetType(url: url))
            return mapResponse(from: data)
        } catch {
            return .failure(.custom(error))
        }
    }

    func retrieve(parameters: LocationListRequestParameters) async -> LocationListDataResult {
        do {
            let data = try await requester.request(targetType: LocationListNetworkTargetType.filter(parameters))
            return mapResponse(from: data)
        } catch {
            return .failure(.custom(error))
        }
    }
}

private extension RemoteLocationListDataSource {
    func mapResponse(from data: Data) -> LocationListDataResult {
        let decoder = JSONDecoder()
        do {
            return try .success(decoder.decode(LocationListResponse.self, from: data))
        } catch {
            return .failure(LocationListDataSourceError.unableToDecode)
        }
    }
}
