import Domain
import SwiftUtils

protocol LocationListViewMapper {
    func map(from listInfo: LocationListInfo, shouldReload: Bool) -> LocationListPresentation
    func map(from error: GetLocationListError) -> LocationListError
}

struct DefaultLocationListViewMapper: LocationListViewMapper {
    func map(from listInfo: LocationListInfo, shouldReload _: Bool) -> LocationListPresentation {
        let locations = listInfo.locations.map {
            LocationPresentation(
                title: $0.name,
                dimension: "\($0.dimension.firstUppercased) · \($0.type)",
                model: $0
            )
        }
        let episodeListPresentation = LocationListPresentation.data(
            locations: locations,
            hasMore: listInfo.areMoreAvailable
        )
        return episodeListPresentation
    }

    func map(from error: GetLocationListError) -> LocationListError {
        switch error {
        case .unableToGetList:
            return LocationListError(
                title: "Oh, geez Rick!",
                description: "There are no locations to show right now."
            )
        }
    }
}
