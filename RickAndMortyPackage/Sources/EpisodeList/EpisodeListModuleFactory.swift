import Domain
import SwiftUI
import SwiftUIUtils

public struct EpisodeListModuleFactory {
    let dependencies: Dependencies
    public let useCases = UseCases()

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    public func make() -> some View {
        let navigator = EpisodeListNavigator(dependencies: dependencies)
        let viewModel = EpisodeListViewModel(navigator: navigator)
        return EpisodeListView(viewModel: viewModel)
    }
}

public extension EpisodeListModuleFactory {
    final class Dependencies {
        private(set) var episodeDetail: (Episode) -> AnyView

        public init() {
            episodeDetail = { _ in AnyView(EmptyView()) }
        }

        public func configure(episodeDetail: @escaping (Episode) -> AnyView) {
            self.episodeDetail = episodeDetail
        }
    }
}

public extension EpisodeListModuleFactory {
    struct UseCases {
        public let getEpisodeList: GetEpisodeListUseCase = GetEpisodeList()
    }
}
