import Combine
import Dispatch
import Domain
import Foundation
import struct SwiftUI.AnyView

protocol LocationListViewModelInput {
    func showLocation(_ location: Location) -> AnyView
    func scrollViewIsNearBottom()
    func onAppear()
}

protocol LocationListViewModelOutput {
    var state: ViewState { get }
}

protocol LocationListViewModelType: ObservableObject {
    var input: LocationListViewModelInput { get }
    var output: LocationListViewModelOutput { get }
}

enum ViewState {
    case display(locationList: LocationListPresentation)
    case showError(_ error: LocationListError)

    var locationList: LocationListPresentation {
        switch self {
        case let .display(locationList):
            return locationList
        case .showError:
            return .data(locations: [], hasMore: false)
        }
    }

    var isPlaceholderShown: Bool {
        switch self {
        case let .display(locationList):
            return locationList.isPlaceholder
        case .showError:
            return false
        }
    }
}

final class LocationListViewModel: LocationListViewModelOutput {
    @Published private(set) var state: ViewState = .display(locationList: .placeholder(numberOfItems: 20))
    private var nextPageRequest: GetLocationListType?
    private var cancellables = Set<AnyCancellable>()
    private let navigator: LocationListWireframe
    private let dependencies: Dependencies

    init(
        navigator: LocationListWireframe,
        dependencies: Dependencies = Dependencies()
    ) {
        self.navigator = navigator
        self.dependencies = dependencies
    }

    private func retrieveLocations(requestType: GetLocationListType, shouldReload: Bool) {
        dependencies.getLocationList.retrieve(requestType: requestType)
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
                let locationList = self.dependencies.locationListViewMapper.map(
                    from: listInfo,
                    shouldReload: shouldReload
                )
                let currentLocations = shouldReload ? [] : self.state.locationList.data
                let locations = currentLocations + locationList.data
                let presentation = LocationListPresentation.data(
                    locations: locations,
                    hasMore: locationList.hasMore
                )
                self.nextPageRequest = listInfo.nextPageRequest
                self.state = .display(locationList: presentation)
            }
            .store(in: &cancellables)
    }

    private func mapError(_ error: GetLocationListError, shouldReload: Bool) {
        guard shouldReload else { return }
        let errorState = dependencies.locationListViewMapper.map(from: error)
        state = .showError(errorState)
    }
}

extension LocationListViewModel: LocationListViewModelInput {
    func onAppear() {
        guard state.isPlaceholderShown else { return }
        retrieveLocations(requestType: .homePage, shouldReload: true)
    }

    func showLocation(_ location: Location) -> AnyView {
        navigator.showLocation(location)
    }

    func scrollViewIsNearBottom() {
        guard let nextPageRequest = nextPageRequest else { return }
        retrieveLocations(requestType: nextPageRequest, shouldReload: false)
    }
}

extension LocationListViewModel: LocationListViewModelType {
    var input: LocationListViewModelInput { self }
    var output: LocationListViewModelOutput { self }
}

// MARK: - Dependencies

extension LocationListViewModel {
    struct Dependencies {
        let getLocationList: GetLocationListUseCase
        let locationListViewMapper: LocationListViewMapper

        init(
            getLocationList: GetLocationListUseCase = GetLocationList(),
            locationListViewMapper: LocationListViewMapper = DefaultLocationListViewMapper()
        ) {
            self.getLocationList = getLocationList
            self.locationListViewMapper = locationListViewMapper
        }
    }
}
