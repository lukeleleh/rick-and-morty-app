import Domain
import SwiftUI

protocol LocationDetailWireframe {
    func showCharacter(_ character: Character) -> AnyView
}

struct LocationDetailNavigator: LocationDetailWireframe {
    private let dependencies: LocationDetailModuleFactory.Dependencies

    init(dependencies: LocationDetailModuleFactory.Dependencies) {
        self.dependencies = dependencies
    }

    func showCharacter(_ character: Character) -> AnyView {
        dependencies.characterDetail(character)
    }
}
