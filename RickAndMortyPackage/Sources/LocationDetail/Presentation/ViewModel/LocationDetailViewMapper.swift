import Domain
import SwiftUtils

protocol LocationDetailViewMapper {
    func map(from location: Location) -> LocationDetailPresentation
    func map(
        from listInfo: CharacterListInfo,
        for presentation: LocationDetailPresentation
    ) -> LocationDetailPresentation
}

struct DefaultCharacterDetailViewMapper: LocationDetailViewMapper {
    func map(from location: Location) -> LocationDetailPresentation {
        let sections = [makeGeneralInfoSection(from: location)]
        return LocationDetailPresentation(
            name: location.name,
            sections: sections,
            hasCharacters: location.numberOfCaracters != 0,
            characters: .placeholder(numberOfItems: location.numberOfCaracters)
        )
    }

    func map(
        from listInfo: CharacterListInfo,
        for presentation: LocationDetailPresentation
    ) -> LocationDetailPresentation {
        let characters = listInfo.characters.map { character in
            LocationDetailPresentation.CharacterPresentationData(
                image: character.image,
                name: character.name,
                model: character
            )
        }

        return LocationDetailPresentation(
            name: presentation.name,
            sections: presentation.sections,
            hasCharacters: !characters.isEmpty,
            characters: .data(characters)
        )
    }

    private func makeGeneralInfoSection(from location: Location) -> LocationDetailPresentation.Section {
        let infoRows: [LocationDetailPresentation.InfoRow] = [
            .init(emojiIcon: "🪐", title: "Type", value: location.type),
            .init(emojiIcon: "✨", title: "Dimension", value: location.dimension.firstUppercased)
        ]
        return .init(title: "Info", rows: infoRows)
    }
}
