import SwiftUI
import SwiftUIUtils

struct LocationDetailView<ViewModel>: View where ViewModel: LocationDetailViewModelType {
    @StateObject var viewModel: ViewModel

    var body: some View {
        List {
            let presentation = viewModel.output.state
            ForEach(presentation.sections, id: \.self) { section in
                Section(header: Text(section.title)) {
                    ForEach(section.rows, id: \.self) { rowInfo in
                        ListInfoRowView(label: rowInfo.title, icon: rowInfo.emojiIcon, value: rowInfo.value)
                    }
                }
            }

            Section(header: Text("Residents")) {
                if presentation.hasCharacters {
                    ForEach(presentation.characters.data, id: \.self) { characterData in
                        NavigationLink(destination: LazyView(makeDestination(for: characterData))) {
                            HStack {
                                URLImage(imageUrl: characterData.image)
                                    .clipShape(Circle())
                                    .shadow(radius: 6)
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                Text(characterData.name)
                            }
                        }
                        .redacted(reason: presentation.characters.isPlaceholder ? .placeholder : [])
                    }
                } else {
                    Text("None")
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle(viewModel.output.state.name)
        .onAppear(perform: viewModel.input.onAppear)
    }

    @ViewBuilder
    private func makeDestination(for character: LocationDetailPresentation.CharacterPresentationData) -> some View {
        viewModel.input.showCharacter(character.model)
    }
}

// struct LocationDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let dependencies = LocationDetailModuleFactory.Dependencies(getCharacterList)
//        return LocationDetailModuleFactory(dependencies: dependencies).make(location: .mock)
//    }
// }
