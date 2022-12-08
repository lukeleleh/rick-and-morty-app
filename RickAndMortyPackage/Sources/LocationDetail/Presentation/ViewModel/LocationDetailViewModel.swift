import Combine
import Dispatch
import Domain
import Foundation
import struct SwiftUI.AnyView

protocol LocationDetailViewModelInput {
    func onAppear()
    func showCharacter(_ character: Character) -> AnyView
}

protocol LocationDetailViewModelOutput {
    var state: ViewState { get }
}

protocol LocationDetailViewModelType: ObservableObject {
    var input: LocationDetailViewModelInput { get }
    var output: LocationDetailViewModelOutput { get }
}

typealias ViewState = LocationDetailPresentation

final class LocationDetailViewModel: LocationDetailViewModelOutput {
    @Published private(set) var state: ViewState
    private var cancellables = Set<AnyCancellable>()
    private let location: Location
    private let navigator: LocationDetailWireframe
    private let dependencies: Dependencies

    init(
        location: Location,
        navigator: LocationDetailWireframe,
        dependencies: Dependencies
    ) {
        self.location = location
        self.navigator = navigator
        self.dependencies = dependencies
        state = dependencies.locationDetailViewMapper.map(from: location)
    }

    private func retrieveLocationCharacters() {
        guard let locationCharactersUrl = location.residentListUrl else { return }
        dependencies.getCharacterList.retrieve(requestType: .url(locationCharactersUrl))
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] listInfo in
                guard let self = self else { return }
                self.state = self.dependencies.locationDetailViewMapper.map(from: listInfo, for: self.state)
            }
            .store(in: &cancellables)
    }
}

extension LocationDetailViewModel: LocationDetailViewModelInput {
    func onAppear() {
        guard state.characters.isPlaceholder else { return }
        retrieveLocationCharacters()
    }

    func showCharacter(_ character: Character) -> AnyView {
        navigator.showCharacter(character)
    }
}

extension LocationDetailViewModel: LocationDetailViewModelType {
    var input: LocationDetailViewModelInput { self }
    var output: LocationDetailViewModelOutput { self }
}

// MARK: - Dependencies

extension LocationDetailViewModel {
    struct Dependencies {
        let getCharacterList: GetCharacterListUseCase
        let locationDetailViewMapper: LocationDetailViewMapper

        init(
            getCharacterList: GetCharacterListUseCase,
            locationDetailViewMapper: LocationDetailViewMapper = DefaultCharacterDetailViewMapper()
        ) {
            self.getCharacterList = getCharacterList
            self.locationDetailViewMapper = locationDetailViewMapper
        }
    }
}
