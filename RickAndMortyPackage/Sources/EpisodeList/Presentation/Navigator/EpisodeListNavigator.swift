import Domain
import SwiftUI

protocol EpisodeListWireframe {
    func showEpisode(_ episode: Episode) -> AnyView
}

struct EpisodeListNavigator: EpisodeListWireframe {
    private let dependencies: EpisodeListModuleFactory.Dependencies

    init(dependencies: EpisodeListModuleFactory.Dependencies) {
        self.dependencies = dependencies
    }

    func showEpisode(_ episode: Episode) -> AnyView {
        dependencies.episodeDetail(episode)
    }
}
