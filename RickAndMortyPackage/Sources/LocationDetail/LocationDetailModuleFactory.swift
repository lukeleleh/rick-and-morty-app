import Domain
import SwiftUI

public struct LocationDetailModuleFactory {
    let dependencies: Dependencies

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    public func make(location: Location) -> some View {
        let navigator = LocationDetailNavigator(dependencies: dependencies)
        let viewModelDependencies = LocationDetailViewModel.Dependencies(getCharacterList: dependencies.getCharacterList)
        let viewModel = LocationDetailViewModel(location: location, navigator: navigator, dependencies: viewModelDependencies)
        return LocationDetailView(viewModel: viewModel)
    }
}

public extension LocationDetailModuleFactory {
    final class Dependencies {
        public typealias CharacterDetailScreen = (Character) -> AnyView

        private(set) var characterDetail: CharacterDetailScreen = { _ in AnyView(EmptyView()) }

        let getCharacterList: GetCharacterListUseCase

        public init(getCharacterList: GetCharacterListUseCase) {
            self.getCharacterList = getCharacterList
        }

        public func configure(characterDetail: @escaping CharacterDetailScreen) {
            self.characterDetail = characterDetail
        }
    }
}
