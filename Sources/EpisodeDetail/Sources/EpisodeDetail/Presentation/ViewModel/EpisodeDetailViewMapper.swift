import Domain
import SwiftUtils

protocol EpisodeDetailViewMapper {
    func map(from episode: Episode) -> EpisodeDetailPresentation
    func map(
        from listInfo: CharacterListInfo,
        for presentation: EpisodeDetailPresentation
    ) -> EpisodeDetailPresentation
}

struct DefaultCharacterDetailViewMapper: EpisodeDetailViewMapper {
    func map(from episode: Episode) -> EpisodeDetailPresentation {
        let sections = [makeGeneralInfoSection(from: episode)]
        return EpisodeDetailPresentation(
            name: episode.name,
            sections: sections,
            characters: .placeholder(numberOfItems: episode.numberOfCaracters)
        )
    }

    func map(
        from listInfo: CharacterListInfo,
        for presentation: EpisodeDetailPresentation
    ) -> EpisodeDetailPresentation {
        let characters = listInfo.characters.map { character in
            EpisodeDetailPresentation.CharacterPresentationData(
                image: character.image,
                name: character.name,
                model: character
            )
        }

        return EpisodeDetailPresentation(
            name: presentation.name,
            sections: presentation.sections,
            characters: .data(characters)
        )
    }

    private func makeGeneralInfoSection(from episode: Episode) -> EpisodeDetailPresentation.Section {
        let infoRows: [EpisodeDetailPresentation.InfoRow] = [
            .init(emojiIcon: "📺", title: "Episode", value: episode.episode),
            .init(emojiIcon: "📅", title: "Air date", value: episode.airDate)
        ]
        return .init(title: "Info", rows: infoRows)
    }
}
