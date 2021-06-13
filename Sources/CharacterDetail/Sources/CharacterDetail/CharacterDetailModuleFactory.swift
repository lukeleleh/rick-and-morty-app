import Domain
import SwiftUI

public struct CharacterDetailModuleFactory {
    let dependencies: Dependencies

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    public func make(character: Character) -> some View {
        let navigator = CharacterDetailNavigator(dependencies: dependencies)
        let viewModelDependencies = CharacterDetailViewModel.Dependencies(getEpisodeList: dependencies.getEpisodeList)
        let viewModel = CharacterDetailViewModel(
            character: character,
            navigator: navigator,
            dependencies: viewModelDependencies
        )
        return CharacterDetailView(viewModel: viewModel)
    }
}

public extension CharacterDetailModuleFactory {
    final class Dependencies {
        public typealias EpisodeDetailScreen = (Episode) -> AnyView

        private(set) var episodeDetail: EpisodeDetailScreen = { _ in AnyView(EmptyView()) }

        let getEpisodeList: GetEpisodeListUseCase

        public init(getEpisodeList: GetEpisodeListUseCase) {
            self.getEpisodeList = getEpisodeList
        }

        public func configure(episodeDetail: @escaping EpisodeDetailScreen) {
            self.episodeDetail = episodeDetail
        }
    }
}
