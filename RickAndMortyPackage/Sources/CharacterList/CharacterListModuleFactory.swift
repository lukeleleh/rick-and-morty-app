import Domain
import SwiftUI

public struct CharacterListModuleFactory {
    let dependencies: Dependencies
    public let useCases = UseCases()

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    public func make() -> some View {
        let navigator = CharacterListNavigator(dependencies: dependencies)
        let viewModel = CharacterListViewModel(navigator: navigator)
        return CharacterListView(viewModel: viewModel)
    }
}

public extension CharacterListModuleFactory {
    final class Dependencies {
        public typealias CharacterDetailScreen = (Character) -> AnyView
        public typealias FiltersScreen = (
            _ selectedFilters: Filters?,
            _ isPresented: Binding<Bool>,
            _ completion: @escaping (Filters) -> Void
        ) -> AnyView

        private(set) var characterDetail: CharacterDetailScreen
        private(set) var filters: FiltersScreen

        public init() {
            characterDetail = { _ in AnyView(EmptyView()) }
            filters = { _, _, _ in AnyView(EmptyView()) }
        }

        public func configure(
            characterDetail: @escaping CharacterDetailScreen,
            filters: @escaping FiltersScreen
        ) {
            self.characterDetail = characterDetail
            self.filters = filters
        }
    }
}

public extension CharacterListModuleFactory {
    struct UseCases {
        public let getCharacterList: GetCharacterListUseCase = GetCharacterList()
    }
}
