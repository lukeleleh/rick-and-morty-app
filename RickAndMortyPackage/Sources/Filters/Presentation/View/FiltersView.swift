import SwiftUI
import SwiftUIUtils

struct FiltersView: View {
    @ObservedObject var viewModel: FiltersViewModel

    var body: some View {
        NavigationView {
            Form {
                ForEach(viewModel.output.presentation.sections.indices) { index in
                    let section = viewModel.output.presentation.sections[index]
                    Section(header: Text(section.title)) {
                        Picker(section.title, selection: $viewModel.presentation.sections[index].selectedOption) {
                            ForEach(section.options, id: \.self) { option in
                                Text(option.title).tag(option as FiltersPresentation.Section.Option?)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }

                Section {
                    Button(action: viewModel.input.applyFilters) {
                        Text("Apply")
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarItems(trailing: Button(action: viewModel.input.resetFilters) {
                HStack {
                    Text("Reset")
                }
            })
        }
        .onAppear(perform: viewModel.input.onViewAppear)
    }
}

struct FiltersView_Previews: PreviewProvider {
    @State private static var isPresented = false

    static var previews: some View {
        FiltersModuleFactory.make(selectedFilters: nil, isPresented: $isPresented) { _ in }
    }
}
