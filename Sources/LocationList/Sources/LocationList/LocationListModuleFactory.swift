import Domain
import SwiftUI
import SwiftUIUtils

public struct LocationListModuleFactory {
    let dependencies: Dependencies

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    public func make() -> some View {
        let navigator = LocationListNavigator(dependencies: dependencies)
        let viewModel = LocationListViewModel(navigator: navigator)
        let view = LocationListView(viewModel: viewModel)
        return view
    }
}

public extension LocationListModuleFactory {
    final class Dependencies {
        private(set) var locationDetail: (Location) -> AnyView

        public init() {
            locationDetail = { _ in AnyView(EmptyView()) }
        }

        public func configure(locationDetail: @escaping (Location) -> AnyView) {
            self.locationDetail = locationDetail
        }
    }
}
