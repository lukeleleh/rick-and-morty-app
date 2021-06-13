import Domain
import SwiftUI
import SwiftUIUtils

public enum FiltersModuleFactory {
    public static func make(
        selectedFilters: Filters?,
        isPresented: Binding<Bool>,
        completion: @escaping (Filters) -> Void
    ) -> some View {
        let navigator = FiltersWireframe(isPresented: isPresented, completion: completion)
        let viewModel = FiltersViewModel(selectedFilters: selectedFilters, navigator: navigator)
        return FiltersView(viewModel: viewModel)
    }
}
