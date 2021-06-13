import SwiftUI

struct EpisodeListView<ViewModel>: View where ViewModel: EpisodeListViewModelType {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        NavigationView {
            stateMainView
                .navigationTitle("Episodes")

            Text("Select an episode")
                .font(.largeTitle)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: viewModel.input.onAppear)
    }
}

private extension EpisodeListView {
    @ViewBuilder
    var stateMainView: some View {
        switch viewModel.output.state {
        case .display:
            episodeList
        case let .showError(error):
            VStack(spacing: 6) {
                Text(error.title)
                    .font(.title)
                Text(error.description)
            }
            .padding()
        }
    }

    var episodeList: some View {
        List {
            let episodeList = viewModel.output.state.episodeList
            EpisodesView(episodeList: episodeList, episodeDetail: viewModel.input.showEpisode)
            if episodeList.hasMore {
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

struct EpisodeListView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencies = EpisodeListModuleFactory.Dependencies()
        return EpisodeListModuleFactory(dependencies: dependencies).make()
    }
}
