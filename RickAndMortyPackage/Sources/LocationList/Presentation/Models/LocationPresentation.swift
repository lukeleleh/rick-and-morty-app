import struct Domain.Location
import Foundation

// MARK: - Element

struct LocationPresentation: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let dimension: String
    let model: Location
}

enum LocationListPresentation {
    case data(locations: [LocationPresentation], hasMore: Bool)
    case placeholder(numberOfItems: Int)

    var data: [LocationPresentation] {
        switch self {
        case let .data(locations, _):
            return locations
        case let .placeholder(numberOfItems):
            let locations = [Int](0 ..< numberOfItems).map { _ in
                LocationPresentation(title: "Title placeholder", dimension: "Dimension placeholder", model: .mock)
            }
            return locations
        }
    }

    var hasMore: Bool {
        switch self {
        case let .data(_, hasMore):
            return hasMore
        case .placeholder:
            return false
        }
    }

    var isPlaceholder: Bool {
        switch self {
        case .data:
            return false
        case .placeholder:
            return true
        }
    }
}

// MARK: - Error

struct LocationListError {
    let title: String
    let description: String
}
