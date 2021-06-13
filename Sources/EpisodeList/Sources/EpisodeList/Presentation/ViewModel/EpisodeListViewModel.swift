import Combine
import Dispatch
import Domain
import struct Domain.Episode
import Foundation
import struct SwiftUI.AnyView

protocol EpisodeListViewModelInput {
    func onAppear()
    func showEpisode(_ episode: Episode) -> AnyView
    func scrollViewIsNearBottom()
}

protocol EpisodeListViewModelOutput {
    var state: ViewState { get }
}

protocol EpisodeListViewModelType: ObservableObject {
    var input: EpisodeListViewModelInput { get }
    var output: EpisodeListViewModelOutput { get }
}

enum ViewState {
    case display(episodeList: EpisodeListPresentation)
    case showError(_ error: EpisodeListError)

    var episodeList: EpisodeListPresentation {
        switch self {
        case let .display(episodeList):
            return episodeList
        case .showError:
            return .data(episodes: [], hasMore: false)
        }
    }

    var isPlaceholderShown: Bool {
        switch self {
        case let .display(episodeList):
            return episodeList.isPlaceholder
        case .showError:
            return false
        }
    }
}

final class EpisodeListViewModel: EpisodeListViewModelOutput {
    @Published private(set) var state: ViewState = .display(episodeList: .placeholder(numberOfItems: 20))
    private var nextPageRequest: GetEpisodeListType?
    private var cancellables = Set<AnyCancellable>()
    private let navigator: EpisodeListWireframe
    private let dependencies: Dependencies

    init(
        navigator: EpisodeListWireframe,
        dependencies: Dependencies = Dependencies()
    ) {
        self.navigator = navigator
        self.dependencies = dependencies
    }

    private func retrieveEpisodes(requestType: GetEpisodeListType, shouldReload: Bool) {
        dependencies.getEpisodeList.retrieve(requestType: requestType)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.mapError(error, shouldReload: shouldReload)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] listInfo in
                guard let self = self else { return }
                let episodeList = self.dependencies.episodeListViewMapper.map(from: listInfo, shouldReload: shouldReload)
                let currentEpisodes = shouldReload ? [] : self.state.episodeList.data
                let episodes = currentEpisodes + episodeList.data
                let presentation = EpisodeListPresentation.data(
                    episodes: episodes,
                    hasMore: episodeList.hasMore
                )
                self.nextPageRequest = listInfo.nextPageRequest
                self.state = .display(episodeList: presentation)
            }
            .store(in: &cancellables)
    }

    private func mapError(_ error: GetEpisodeListError, shouldReload: Bool) {
        guard shouldReload else { return }
        let errorState = dependencies.episodeListViewMapper.map(from: error)
        state = .showError(errorState)
    }
}

extension EpisodeListViewModel: EpisodeListViewModelInput {
    func onAppear() {
        guard state.isPlaceholderShown else { return }
        retrieveEpisodes(requestType: .homePage, shouldReload: true)
    }

    func showEpisode(_ episode: Episode) -> AnyView {
        navigator.showEpisode(episode)
    }

    func scrollViewIsNearBottom() {
        guard let nextPageRequest = nextPageRequest else { return }
        retrieveEpisodes(requestType: nextPageRequest, shouldReload: false)
    }
}

extension EpisodeListViewModel: EpisodeListViewModelType {
    var input: EpisodeListViewModelInput { self }
    var output: EpisodeListViewModelOutput { self }
}

// MARK: - Dependencies

extension EpisodeListViewModel {
    struct Dependencies {
        let getEpisodeList: GetEpisodeListUseCase
        let episodeListViewMapper: EpisodeListViewMapper

        init(
            getEpisodeList: GetEpisodeListUseCase = GetEpisodeList(),
            episodeListViewMapper: EpisodeListViewMapper = DefaultEpisodeListViewMapper()
        ) {
            self.getEpisodeList = getEpisodeList
            self.episodeListViewMapper = episodeListViewMapper
        }
    }
}
