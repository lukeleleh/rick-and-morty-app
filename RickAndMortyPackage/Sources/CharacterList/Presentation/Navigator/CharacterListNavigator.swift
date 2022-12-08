import Domain
import SwiftUI

protocol CharacterListWireframe {
    func showFilters(
        selectedFilters: Filters?,
        areFiltersPresented: Binding<Bool>,
        completion: @escaping (Filters) -> Void
    ) -> AnyView
    func showCharacter(_ character: Character) -> AnyView
}

struct CharacterListNavigator: CharacterListWireframe {
    private let dependencies: CharacterListModuleFactory.Dependencies

    init(dependencies: CharacterListModuleFactory.Dependencies) {
        self.dependencies = dependencies
    }

    func showFilters(
        selectedFilters: Filters?,
        areFiltersPresented: Binding<Bool>,
        completion: @escaping (Filters) -> Void
    ) -> AnyView {
        dependencies.filters(selectedFilters, areFiltersPresented, completion)
    }

    func showCharacter(_ character: Character) -> AnyView {
        dependencies.characterDetail(character)
    }
}
