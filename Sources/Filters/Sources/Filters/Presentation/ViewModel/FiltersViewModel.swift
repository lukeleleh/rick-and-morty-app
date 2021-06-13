import Domain
import Foundation
import SwiftUtils

protocol FiltersViewModelInput {
    func onViewAppear()
    func resetFilters()
    func applyFilters()
}

protocol FiltersViewModelOutput {
    var presentation: FiltersPresentation { get }
}

protocol FiltersViewModelType {
    var input: FiltersViewModelInput { get }
    var output: FiltersViewModelOutput { get }
}

final class FiltersViewModel: FiltersViewModelOutput, ObservableObject {
    @Published var presentation: FiltersPresentation

    private let defaultFilters = FiltersPresentation(sections: [
        FiltersPresentation.Section(
            type: .status,
            options: Character.Status.allCases.map(FiltersPresentation.Section.Option.init(status:))
        ),
        FiltersPresentation.Section(
            type: .gender,
            options: Character.Gender.allCases.map(FiltersPresentation.Section.Option.init(gender:))
        )
    ])
    private let selectedFilters: Filters?
    private let navigator: FiltersNavigator
    private let dependencies: Dependencies

    init(
        selectedFilters: Filters?,
        navigator: FiltersNavigator,
        dependencies: Dependencies = Dependencies()
    ) {
        self.selectedFilters = selectedFilters
        self.navigator = navigator
        self.dependencies = dependencies
        presentation = defaultFilters
    }
}

extension FiltersViewModel: FiltersViewModelInput {
    func onViewAppear() {
        let sections = presentation.sections
        if let selectedStatus = selectedFilters?.status,
            let statusIndex = sections.firstIndex(where: { $0.type == .status }) {
            let statusOption = FiltersPresentation.Section.Option(status: selectedStatus)
            presentation.sections[statusIndex].selectedOption = statusOption
        }

        if let selectedGender = selectedFilters?.gender,
            let genderIndex = sections.firstIndex(where: { $0.type == .gender }) {
            let genderOption = FiltersPresentation.Section.Option(gender: selectedGender)
            presentation.sections[genderIndex].selectedOption = genderOption
        }
    }

    func resetFilters() {
        presentation = defaultFilters
    }

    func applyFilters() {
        let sections = presentation.sections
        let statusOption = sections.first { $0.type == .status }?.selectedOption
        let status = statusOption.flatMap { Character.Status(rawValue: $0.id) }
        let genderOption = sections.first { $0.type == .gender }?.selectedOption
        let gender = genderOption.flatMap { Character.Gender(rawValue: $0.id) }
        let filters = Filters(status: status, gender: gender)
        navigator.close(selectedFilters: filters)
    }
}

extension FiltersViewModel: FiltersViewModelType {
    var input: FiltersViewModelInput { self }
    var output: FiltersViewModelOutput { self }
}

// MARK: - Dependencies

extension FiltersViewModel {
    struct Dependencies {}
}

private extension FiltersPresentation.Section.Option {
    init(status: Character.Status) {
        id = status.rawValue
        title = status.rawValue.uppercased()
    }
}

private extension FiltersPresentation.Section.Option {
    init(gender: Character.Gender) {
        id = gender.rawValue
        title = gender.rawValue.uppercased()
    }
}
