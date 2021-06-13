import Combine
import Dispatch
import Domain
import Foundation
import struct SwiftUI.AnyView

protocol EpisodeDetailViewModelInput {
    func onAppear()
    func showCharacter(_ character: Character) -> AnyView
}

protocol EpisodeDetailViewModelOutput {
    var state: ViewState { get }
}

protocol EpisodeDetailViewModelType: ObservableObject {
    var input: EpisodeDetailViewModelInput { get }
    var output: EpisodeDetailViewModelOutput { get }
}

typealias ViewState = EpisodeDetailPresentation

final class EpisodeDetailViewModel: EpisodeDetailViewModelOutput {
    @Published private(set) var state: ViewState
    private let episode: Episode
    private let navigator: EpisodeDetailWireframe
    private let dependencies: Dependencies
    private var cancellables = Set<AnyCancellable>()

    init(
        episode: Episode,
        navigator: EpisodeDetailWireframe,
        dependencies: Dependencies
    ) {
        self.episode = episode
        self.navigator = navigator
        self.dependencies = dependencies
        state = dependencies.episodeDetailViewMapper.map(from: episode)
    }

    private func retrieveEpisodeCharacters() {
        dependencies.getCharacterList.retrieve(requestType: .url(episode.characterListUrl))
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] listInfo in
                guard let self = self else { return }
                self.state = self.dependencies.episodeDetailViewMapper.map(from: listInfo, for: self.state)
            }
            .store(in: &cancellables)
    }
}

extension EpisodeDetailViewModel: EpisodeDetailViewModelInput {
    func onAppear() {
        guard state.characters.isPlaceholder else { return }
        retrieveEpisodeCharacters()
    }

    func showCharacter(_ character: Character) -> AnyView {
        navigator.showCharacter(character)
    }
}

extension EpisodeDetailViewModel: EpisodeDetailViewModelType {
    var input: EpisodeDetailViewModelInput { self }
    var output: EpisodeDetailViewModelOutput { self }
}

// MARK: - Dependencies

extension EpisodeDetailViewModel {
    struct Dependencies {
        let getCharacterList: GetCharacterListUseCase
        let episodeDetailViewMapper: EpisodeDetailViewMapper

        init(
            getCharacterList: GetCharacterListUseCase,
            episodeDetailViewMapper: EpisodeDetailViewMapper = DefaultCharacterDetailViewMapper()
        ) {
            self.getCharacterList = getCharacterList
            self.episodeDetailViewMapper = episodeDetailViewMapper
        }
    }
}
