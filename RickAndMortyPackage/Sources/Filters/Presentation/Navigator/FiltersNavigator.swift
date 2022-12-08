import Domain
import SwiftUI

protocol FiltersNavigator {
    func close(selectedFilters: Filters)
}

struct FiltersWireframe: FiltersNavigator {
    @Binding private var isPresented: Bool
    private let completion: (Filters) -> Void

    init(isPresented: Binding<Bool>, completion: @escaping (Filters) -> Void) {
        _isPresented = isPresented
        self.completion = completion
    }

    func close(selectedFilters: Filters) {
        isPresented = false
        completion(selectedFilters)
    }
}

struct PreviewFiltersWireframe: FiltersNavigator {
    func close(selectedFilters _: Filters) {}
}
