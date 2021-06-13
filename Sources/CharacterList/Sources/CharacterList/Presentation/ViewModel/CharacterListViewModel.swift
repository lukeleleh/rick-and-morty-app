import Combine
import Dispatch
import Domain
import Foundation
import struct SwiftUI.AnyView
import struct SwiftUI.Binding

protocol CharacterListViewModelInput {
    func showFilters(isPresented: Binding<Bool>) -> AnyView
    func showCharacter(_ character: Character) -> AnyView
    func scrollViewIsNearBottom()
    func onAppear()
}

protocol CharacterListViewModelOutput {
    var state: ViewState { get }
    var areFiltersSelected: Bool { get }
    var scrollToCharacterId: UUID? { get }
}

protocol CharacterListViewModelType: ObservableObject {
    var input: CharacterListViewModelInput { get }
    var output: CharacterListViewModelOutput { get }
}

enum ViewState {
    case display(characterList: CharacterListPresentation)
    case showError(_ error: CharacterListError)

    var characterList: CharacterListPresentation {
        switch self {
        case let .display(characterList):
            return characterList
        case .showError:
            return .data(characters: [], hasMore: false)
        }
    }

    fileprivate var isPlaceholderShown: Bool {
        switch self {
        case let .display(characterList):
            return characterList.isPlaceholder
        case .showError:
            return false
        }
    }
}

final class CharacterListViewModel: CharacterListViewModelOutput {
    @Published private(set) var state: ViewState = .display(characterList: .placeholder(numberOfItems: 20))
    @Published private(set) var areFiltersSelected = false
    @Published private(set) var scrollToCharacterId: UUID?
    private var nextPageRequest: GetCharacterListType?
    private var selectedFilters = Filters.default
    private var cancellables = Set<AnyCancellable>()
    private let navigator: CharacterListWireframe
    private let dependencies: Dependencies

    init(
        navigator: CharacterListWireframe,
        dependencies: Dependencies = Dependencies()
    ) {
        self.navigator = navigator
        self.dependencies = dependencies
    }

    private func retrieveCharacters(requestType: GetCharacterListType, shouldReload: Bool) {
        dependencies.getCharacterList.retrieve(requestType: requestType)
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
                let characterList = self.dependencies.characterListViewMapper.map(from: listInfo)
                let currentCharacters = shouldReload ? [] : self.state.characterList.data
                let characters = currentCharacters + characterList.data
                let presentation = CharacterListPresentation.data(
                    characters: characters,
                    hasMore: characterList.hasMore
                )
                self.nextPageRequest = listInfo.nextPageRequest
                self.state = .display(characterList: presentation)
                self.areFiltersSelected = !self.selectedFilters.isDefault
                self.scrollToCharacterId = shouldReload ? characters.first?.id : nil
            }
            .store(in: &cancellables)
    }

    private func mapError(_ error: GetCharacterListError, shouldReload: Bool) {
        guard shouldReload else { return }
        let errorState = dependencies.characterListViewMapper.map(from: error)
        state = .showError(errorState)
    }
}

extension CharacterListViewModel: CharacterListViewModelInput {
    func onAppear() {
        guard state.isPlaceholderShown else { return }
        retrieveCharacters(requestType: .homePage, shouldReload: true)
    }

    func showFilters(isPresented: Binding<Bool>) -> AnyView {
        navigator.showFilters(
            selectedFilters: selectedFilters,
            areFiltersPresented: isPresented
        ) { [weak self] selectedFilters in
            let requestType = GetCharacterListType.filtered(selectedFilters)
            self?.selectedFilters = selectedFilters
            self?.retrieveCharacters(requestType: requestType, shouldReload: true)
        }
    }

    func showCharacter(_ character: Character) -> AnyView {
        navigator.showCharacter(character)
    }

    func scrollViewIsNearBottom() {
        guard let nextPageRequest = nextPageRequest else { return }
        retrieveCharacters(requestType: nextPageRequest, shouldReload: false)
    }
}

extension CharacterListViewModel: CharacterListViewModelType {
    var input: CharacterListViewModelInput { self }
    var output: CharacterListViewModelOutput { self }
}

// MARK: - Dependencies

extension CharacterListViewModel {
    struct Dependencies {
        let getCharacterList: GetCharacterListUseCase
        let characterListViewMapper: CharacterListViewMapper

        init(
            getCharacterList: GetCharacterListUseCase = GetCharacterList(),
            characterListViewMapper: CharacterListViewMapper = DefaultCharacterListViewMapper()
        ) {
            self.getCharacterList = getCharacterList
            self.characterListViewMapper = characterListViewMapper
        }
    }
}
