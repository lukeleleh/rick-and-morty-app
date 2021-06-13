import SwiftUI
import SwiftUIUtils

struct CharacterDetailView<ViewModel>: View where ViewModel: CharacterDetailViewModelType {
    @StateObject var viewModel: ViewModel
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    var body: some View {
        GeometryReader { proxy in
            List {
                let presentation = viewModel.output.state
                Section(header: Text("Appearance")) {
                    if verticalSizeClass == .regular {
                        URLImage(imageUrl: presentation.image)
                            .scaledToFill()
                            .cornerRadius(6)
                    } else {
                        HStack {
                            Spacer()
                            URLImage(imageUrl: presentation.image)
                                .clipShape(Circle())
                                .scaledToFit()
                                .frame(height: proxy.size.height * 0.5)
                            Spacer()
                        }
                    }
                }

                ForEach(presentation.sections, id: \.self) { section in
                    Section(header: Text(section.title)) {
                        ForEach(section.rows, id: \.self) { rowInfo in
                            ListInfoRowView(label: rowInfo.title, icon: rowInfo.emojiIcon, value: rowInfo.value)
                        }
                    }
                }

                Section(header: Text(presentation.episodesSectionTitle)) {
                    ForEach(presentation.episodes.data, id: \.self) { episodePresentation in
                        NavigationLink(destination: LazyView(makeDestination(for: episodePresentation))) {
                            VStack(alignment: .leading) {
                                Text(episodePresentation.title)
                                    .font(.headline)
                                Text(episodePresentation.airDate)
                                    .font(.subheadline)
                            }
                        }
                        .redacted(reason: presentation.episodes.isPlaceholder ? .placeholder : [])
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
        .navigationTitle(viewModel.output.state.name)
        .onAppear(perform: viewModel.input.onAppear)
    }

    @ViewBuilder
    private func makeDestination(for episode: CharacterDetailPresentation.EpisodePresentationData) -> some View {
        viewModel.input.showEpisode(episode.model)
    }
}

// struct CharacterDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let dependencies = CharacterDetailModuleFactory.Dependencies(
//            getEpisodeList: GetEpisodeListUseCase,
//            characterEpisodes: { _ in AnyView(EmptyView()) }
//        )
//        return CharacterDetailModuleFactory(dependencies: dependencies).make(character: .mock)
//    }
// }
