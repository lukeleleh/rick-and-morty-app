import Domain
import SwiftUtils

protocol CharacterDetailViewMapper {
    func map(from character: Character) -> CharacterDetailPresentation
    func map(
        from listInfo: EpisodeListInfo,
        for presentation: CharacterDetailPresentation
    ) -> CharacterDetailPresentation
}

struct DefaultCharacterDetailViewMapper: CharacterDetailViewMapper {
    func map(from character: Character) -> CharacterDetailPresentation {
        let sections = [
            makeGeneralInfoSection(from: character),
            makeLocationInfoSection(from: character)
        ]

        return CharacterDetailPresentation(
            image: character.image,
            name: character.name,
            sections: sections,
            episodesSectionTitle: makeEpisodesSectionTitle(from: character),
            episodes: .placeholder(numberOfItems: character.numberOfEpisodes)
        )
    }

    func map(
        from listInfo: EpisodeListInfo,
        for presentation: CharacterDetailPresentation
    ) -> CharacterDetailPresentation {
        let episodes = listInfo.episodes.map { episode in
            CharacterDetailPresentation.EpisodePresentationData(
                title: "\(episode.episode) · \(episode.name)",
                airDate: episode.airDate,
                model: episode
            )
        }

        return CharacterDetailPresentation(
            image: presentation.image,
            name: presentation.name,
            sections: presentation.sections,
            episodesSectionTitle: presentation.episodesSectionTitle,
            episodes: .data(episodes)
        )
    }

    private func makeGeneralInfoSection(from character: Character) -> CharacterDetailPresentation.Section {
        var infoRows: [CharacterDetailPresentation.InfoRow] = [
            .init(emojiIcon: character.status.icon, title: "Status", value: character.status.rawValue.firstUppercased),
            .init(emojiIcon: "🧬", title: "Specie", value: character.species),
            .init(emojiIcon: "👤", title: "Gender", value: character.gender.rawValue.firstUppercased)
        ]

        if let type = character.type, !type.isEmpty {
            infoRows.append(.init(emojiIcon: "🌱", title: "Type", value: type.firstUppercased))
        }

        return .init(title: "Info", rows: infoRows)
    }

    private func makeLocationInfoSection(from character: Character) -> CharacterDetailPresentation.Section {
        let infoRows: [CharacterDetailPresentation.InfoRow] = [
            .init(emojiIcon: "📍", title: "First seen in:", value: character.origin.name),
            .init(emojiIcon: "🗺", title: "Last known location:", value: character.location.name)
        ]

        return .init(title: "Location", rows: infoRows)
    }

    private func makeEpisodesSectionTitle(from character: Character) -> String {
        if character.numberOfEpisodes == 1 {
            return "Episode"
        } else {
            return "Episodes (\(character.numberOfEpisodes))"
        }
    }
}

private extension Character.Status {
    var icon: String {
        switch self {
        case .alive: return "🟢"
        case .dead: return "🔴"
        case .unknown: return "⚪️"
        }
    }
}

private extension Character.Location {
    var name: String {
        switch self {
        case let .known(name, _):
            return name
        case .unknown:
            return "Unknown"
        }
    }
}
