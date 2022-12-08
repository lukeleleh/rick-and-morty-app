import Domain

protocol CharacterListViewMapper {
    func map(from listInfo: CharacterListInfo) -> CharacterListPresentation
    func map(from error: GetCharacterListError) -> CharacterListError
}

struct DefaultCharacterListViewMapper: CharacterListViewMapper {
    func map(from listInfo: CharacterListInfo) -> CharacterListPresentation {
        let characters = listInfo.characters.map { character in
            CharacterPresentation(image: character.image, name: character.name, model: character)
        }
        return .data(characters: characters, hasMore: listInfo.areMoreAvailable)
    }

    func map(from error: GetCharacterListError) -> CharacterListError {
        switch error {
        case .unableToGetList:
            return CharacterListError(
                title: "Oh, geez Rick!",
                description: "There are no characters to show right now."
            )
        }
    }
}

private extension Character.Status {
    var character: String {
        switch self {
        case .alive:
            return "🟢"
        case .dead:
            return "🔴"
        case .unknown:
            return "⚪️"
        }
    }
}
