import Domain
import struct Foundation.URL

protocol LocationListInfoMapper {
    func map(response: LocationList) -> LocationListInfo
    func map(error: LocationListRepositoryError) -> GetLocationListError
}

struct DefaultLocationListInfoMapper: LocationListInfoMapper {
    func map(response: LocationList) -> LocationListInfo {
        LocationListInfo(
            locations: response.elements,
            nextPageRequest: response.info.paginationURL.map(GetLocationListType.url)
        )
    }

    func map(error _: LocationListRepositoryError) -> GetLocationListError {
        .unableToGetList
    }
}
