import struct Domain.Character
import Foundation

// MARK: - Element

struct CharacterPresentation: Identifiable, Hashable {
    let id = UUID()
    let image: URL?
    let name: String
    let model: Character
}

enum CharacterListPresentation {
    case data(characters: [CharacterPresentation], hasMore: Bool)
    case placeholder(numberOfItems: Int)

    var data: [CharacterPresentation] {
        switch self {
        case let .data(characters, _):
            return characters
        case let .placeholder(numberOfItems):
            let characters = [Int](0 ..< numberOfItems).map { _ in
                CharacterPresentation(image: nil, name: "Name placeholder", model: .mock)
            }
            return characters
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

struct CharacterListError {
    let title: String
    let description: String
}
