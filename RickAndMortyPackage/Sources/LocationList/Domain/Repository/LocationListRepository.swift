import struct Foundation.URL

typealias LocationListResult = Swift.Result<LocationList, LocationListRepositoryError>

enum LocationListRepositoryError: Error {
    case unableToDecode
    case dataSource(Error)
}

protocol LocationListRepository {
    func retrieve() async -> LocationListResult
    func retrieve(url: URL) async -> LocationListResult
}
