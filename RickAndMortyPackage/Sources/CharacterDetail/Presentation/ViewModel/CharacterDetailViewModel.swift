import Combine
import Dispatch
import Domain
import Foundation
import struct SwiftUI.AnyView

protocol CharacterDetailViewModelInput {
    func onAppear()
    func showEpisode(_ episode: Episode) -> AnyView
}

protocol CharacterDetailViewModelOutput {
    var state: ViewState { get }
}

protocol CharacterDetailViewModelType: ObservableObject {
    var input: CharacterDetailViewModelInput { get }
    var output: CharacterDetailViewModelOutput { get }
}

typealias ViewState = CharacterDetailPresentation

final class CharacterDetailViewModel: CharacterDetailViewModelOutput {
    @Published private(set) var state: ViewState
    private var cancellables = Set<AnyCancellable>()
    private let character: Character
    private let navigator: CharacterDetailWireframe
    private let dependencies: Dependencies

    init(
        character: Character,
        navigator: CharacterDetailWireframe,
        dependencies: Dependencies
    ) {
        self.character = character
        self.navigator = navigator
        self.dependencies = dependencies
        state = dependencies.characterDetailViewMapper.map(from: character)
    }

    private func retrieveCharacterEpisodes() {
        dependencies.getEpisodeList.retrieve(requestType: .url(character.episodesUrl))
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] listInfo in
                guard let self = self else { return }
                self.state = self.dependencies.characterDetailViewMapper.map(from: listInfo, for: self.state)
            }
            .store(in: &cancellables)
    }
}

extension CharacterDetailViewModel: CharacterDetailViewModelInput {
    func onAppear() {
        guard state.episodes.isPlaceholder else {
            return
        }
        retrieveCharacterEpisodes()
    }

    func showEpisode(_ episode: Episode) -> AnyView {
        navigator.showEpisode(episode)
    }
}

extension CharacterDetailViewModel: CharacterDetailViewModelType {
    var input: CharacterDetailViewModelInput { self }
    var output: CharacterDetailViewModelOutput { self }
}

// MARK: - Dependencies

extension CharacterDetailViewModel {
    struct Dependencies {
        let getEpisodeList: GetEpisodeListUseCase
        let characterDetailViewMapper: CharacterDetailViewMapper

        init(
            getEpisodeList: GetEpisodeListUseCase,
            characterDetailViewMapper: CharacterDetailViewMapper = DefaultCharacterDetailViewMapper()
        ) {
            self.getEpisodeList = getEpisodeList
            self.characterDetailViewMapper = characterDetailViewMapper
        }
    }
}
