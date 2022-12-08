public struct LocationListInfo {
    public let locations: [Location]
    public let nextPageRequest: GetLocationListType?

    public init(locations: [Location], nextPageRequest: GetLocationListType?) {
        self.locations = locations
        self.nextPageRequest = nextPageRequest
    }
}

public extension LocationListInfo {
    var areMoreAvailable: Bool {
        nextPageRequest != nil
    }
}
