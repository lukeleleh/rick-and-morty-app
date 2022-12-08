import Domain
import Foundation

struct LocationDetailPresentation {
    let name: String
    let sections: [Section]
    let hasCharacters: Bool
    let characters: CharacterPresentation
}

// MARK: - Section

extension LocationDetailPresentation {
    struct Section: Hashable {
        let title: String
        let rows: [InfoRow]
    }
}

// MARK: - InfoRow

extension LocationDetailPresentation {
    struct InfoRow: Hashable {
        let emojiIcon: String
        let title: String
        let value: String
    }
}

// MARK: - CharacterPresentation

extension LocationDetailPresentation {
    enum CharacterPresentation: Hashable {
        case data([CharacterPresentationData])
        case placeholder(numberOfItems: Int)

        var data: [CharacterPresentationData] {
            switch self {
            case let .data(characterPresentation):
                return characterPresentation
            case let .placeholder(numberOfItems):
                let placeholder = CharacterPresentationData(image: nil, name: "Name Placeholder", model: .mock)
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

    struct CharacterPresentationData: Identifiable, Hashable {
        let id = UUID()
        let image: URL?
        let name: String
        let model: Character
    }
}
