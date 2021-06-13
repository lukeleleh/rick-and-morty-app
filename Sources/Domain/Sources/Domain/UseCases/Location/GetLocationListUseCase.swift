import Combine
import struct Foundation.URL

public enum GetLocationListError: Error {
    case unableToGetList
}

public enum GetLocationListType {
    case homePage
    case url(URL)
}

public protocol GetLocationListUseCase {
    func retrieve(requestType: GetLocationListType) -> AnyPublisher<LocationListInfo, GetLocationListError>
}
