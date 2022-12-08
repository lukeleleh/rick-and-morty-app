import SwiftUI
import SwiftUIUtils

struct CharacterListView<ViewModel>: View where ViewModel: CharacterListViewModelType {
    @ObservedObject var viewModel: ViewModel
    @State private var showFiltersView = false
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    var body: some View {
        NavigationView {
            stateMainView
                .navigationTitle("Characters")
                .navigationBarItems(trailing: filtersButton)
            Text("Select a character")
                .font(.largeTitle)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: viewModel.input.onAppear)
        .sheet(isPresented: $showFiltersView) { viewModel.input.showFilters(isPresented: $showFiltersView) }
    }
}

private extension CharacterListView {
    var filtersButton: some View {
        Button(action: { showFiltersView.toggle() }) {
            HStack {
                let filtersImageName = viewModel.output.areFiltersSelected
                    ? "line.horizontal.3.decrease.circle.fill"
                    : "line.horizontal.3.decrease.circle"
                Image(systemName: filtersImageName)
                Text("Filters")
            }
        }
    }

    @ViewBuilder
    var stateMainView: some View {
        switch viewModel.output.state {
        case .display:
            charactersGrid
        case let .showError(error):
            VStack(spacing: 6) {
                Text(error.title)
                    .font(.title)
                Text(error.description)
            }
            .padding()
        }
    }

    var columns: [GridItem] {
        let numberOfColumns = verticalSizeClass == .compact ? 3 : 2
        return Array(repeating: GridItem(.flexible()), count: numberOfColumns)
    }

    var charactersGrid: some View {
        let characterList = viewModel.output.state.characterList
        return ScrollViewReader { scrollViewProxy in
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(characterList.data, id: \.id) { character in
                        NavigationLink(destination: LazyView(makeDestination(for: character))) {
                            CharacterView(presentation: character)
                                .redacted(reason: characterList.isPlaceholder ? .placeholder : [])
                        }
                        .allowsHitTesting(!characterList.isPlaceholder)
                        .buttonStyle(PlainButtonStyle())
                    }
                    if characterList.hasMore {
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
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            }
            .onChange(of: viewModel.output.scrollToCharacterId) { characterId in
                guard let characterId = characterId else { return }
                scrollViewProxy.scrollTo(characterId, anchor: .top)
            }
        }
    }

    @ViewBuilder
    func makeDestination(for character: CharacterPresentation) -> some View {
        viewModel.input.showCharacter(character.model)
    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencies = CharacterListModuleFactory.Dependencies()
        return CharacterListModuleFactory(dependencies: dependencies).make()
    }
}
