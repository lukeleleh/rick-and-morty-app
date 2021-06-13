import Foundation

public struct Location: Hashable {
    public let id: String
    public let name: String
    public let type: String
    public let dimension: String
    public let residentListUrl: URL?
    public let numberOfCaracters: Int

    public init(id: String, name: String, type: String, dimension: String, residentListUrl: URL?, numberOfCaracters: Int) {
        self.id = id
        self.name = name
        self.type = type
        self.dimension = dimension
        self.residentListUrl = residentListUrl
        self.numberOfCaracters = numberOfCaracters
    }
}

public extension Location {
    static let mock = Location(
        id: "",
        name: "",
        type: "",
        dimension: "",
        residentListUrl: nil,
        numberOfCaracters: 0
    )
}
