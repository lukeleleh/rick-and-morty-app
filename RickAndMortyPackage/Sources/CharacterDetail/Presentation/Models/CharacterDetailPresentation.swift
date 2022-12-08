import Domain
import Foundation

struct CharacterDetailPresentation {
    let image: URL
    let name: String
    let sections: [Section]
    let episodesSectionTitle: String
    let episodes: EpisodePresentation
}

// MARK: - Section

extension CharacterDetailPresentation {
    struct Section: Hashable {
        let title: String
        let rows: [InfoRow]
    }
}

// MARK: - InfoRow

extension CharacterDetailPresentation {
    struct InfoRow: Hashable {
        let emojiIcon: String
        let title: String
        let value: String
    }
}

// MARK: - EpisodePresentation

extension CharacterDetailPresentation {
    enum EpisodePresentation: Hashable {
        case data([EpisodePresentationData])
        case placeholder(numberOfItems: Int)

        var data: [EpisodePresentationData] {
            switch self {
            case let .data(episodePresentation):
                return episodePresentation
            case let .placeholder(numberOfItems):
                let placeholder = EpisodePresentationData(title: "Title Placeholder", airDate: "Placeholder", model: .mock)
                return Array(repeating: placeholder, count: numberOfItems)
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

    struct EpisodePresentationData: Identifiable, Hashable {
        let id = UUID()
        let title: String
        let airDate: String
        let model: Episode
    }
}
