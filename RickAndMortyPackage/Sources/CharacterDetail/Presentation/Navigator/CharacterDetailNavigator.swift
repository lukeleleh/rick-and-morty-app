import Domain
import SwiftUI

protocol CharacterDetailWireframe {
    func showEpisode(_ episode: Episode) -> AnyView
}

struct CharacterDetailNavigator: CharacterDetailWireframe {
    private let dependencies: CharacterDetailModuleFactory.Dependencies

    init(dependencies: CharacterDetailModuleFactory.Dependencies) {
        self.dependencies = dependencies
    }

    func showEpisode(_ episode: Episode) -> AnyView {
        dependencies.episodeDetail(episode)
    }
}
