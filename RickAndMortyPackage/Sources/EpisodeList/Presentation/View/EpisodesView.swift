import struct Domain.Episode
import SwiftUI
import SwiftUIUtils

struct EpisodesView: View {
    let episodeList: EpisodeListPresentation
    let episodeDetail: (Episode) -> AnyView

    var body: some View {
        ForEach(episodeList.data, id: \.id) { episode in
            NavigationLink(destination: LazyView(episodeDetail(episode.model))) {
                VStack(alignment: .leading) {
                    Text(episode.title)
                        .font(.headline)
                    Text(episode.airDate)
                        .font(.subheadline)
                }
                .redacted(reason: episodeList.isPlaceholder ? .placeholder : [])
            }
            .disabled(episodeList.isPlaceholder)
        }
    }
}

struct EpisodesView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodesView(
            episodeList: EpisodeListPresentation.data(episodes: [], hasMore: false),
            episodeDetail: { _ in AnyView(EmptyView()) }
        )
    }
}
