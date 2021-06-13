import SwiftUI
import SwiftUIUtils

struct LocationListView<ViewModel>: View where ViewModel: LocationListViewModelType {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        NavigationView {
            stateMainView
                .navigationTitle("Locations")

            Text("Select a location")
                .font(.largeTitle)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: viewModel.input.onAppear)
    }
}

private extension LocationListView {
    @ViewBuilder
    var stateMainView: some View {
        switch viewModel.output.state {
        case .display:
            locationList
        case let .showError(error):
            VStack(spacing: 6) {
                Text(error.title)
                    .font(.title)
                Text(error.description)
            }
            .padding()
        }
    }

    var locationList: some View {
        List {
            let locationList = viewModel.output.state.locationList
            ForEach(locationList.data, id: \.id) { location in
                NavigationLink(destination: LazyView(viewModel.input.showLocation(location.model))) {
                    VStack(alignment: .leading) {
                        Text(location.title)
                            .font(.headline)
                        Text(location.dimension)
                            .font(.subheadline)
                    }
                    .redacted(reason: locationList.isPlaceholder ? .placeholder : [])
                }
                .disabled(locationList.isPlaceholder)
            }
            if locationList.hasMore {
                HStack(alignment: .center, spacing: 6) {
                    Spacer()
                    ProgressView()
                    Text("Fetching more")
                        .font(.footnote)
                        .padding([.top, .bottom])
                    Spacer()
                }
                .onAppear(perform: viewModel.input.scrollViewIsNearBottom)
            }
        }
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencies = LocationListModuleFactory.Dependencies()
        return LocationListModuleFactory(dependencies: dependencies).make()
    }
}
