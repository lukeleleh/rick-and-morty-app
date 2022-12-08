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
        Task { @MainActor in
            let characterListResult = await dependencies.getCharacterList.retrieve(requestType: .url(episode.characterListUrl))

            guard let listInfo = try? characterListResult.get() else {
                return
            }

            state = dependencies.episodeDetailViewMapper.map(from: listInfo, for: state)
        }
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
