import struct Domain.Episode
import Foundation

// MARK: - Element

struct EpisodePresentation: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let airDate: String
    let model: Episode
}

enum EpisodeListPresentation {
    case data(episodes: [EpisodePresentation], hasMore: Bool)
    case placeholder(numberOfItems: Int)

    var data: [EpisodePresentation] {
        switch self {
        case let .data(episodes, _):
            return episodes
        case let .placeholder(numberOfItems):
            let episodes = [Int](0 ..< numberOfItems).map { _ in
                EpisodePresentation(title: "Title placeholder", airDate: "Air date placeholder", model: .mock)
            }
            return episodes
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

struct EpisodeListError {
    let title: String
    let description: String
}
