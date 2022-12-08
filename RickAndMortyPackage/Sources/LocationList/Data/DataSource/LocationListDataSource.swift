import Foundation

typealias LocationListDataResult = Swift.Result<LocationListResponse, LocationListDataSourceError>

enum LocationListDataSourceError: Error {
    case unableToDecode
    case custom(Error)
}

protocol LocationListDataSource {
    func retrieve() async -> LocationListDataResult
    func retrieve(url: URL) async -> LocationListDataResult
    func retrieve(parameters: LocationListRequestParameters) async -> LocationListDataResult
}
