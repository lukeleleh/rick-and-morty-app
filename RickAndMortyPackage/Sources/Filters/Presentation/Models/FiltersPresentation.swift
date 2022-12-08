import SwiftUtils

struct FiltersPresentation: Hashable {
    var sections: [Section]
}

// MARK: - Section

extension FiltersPresentation {
    struct Section: Hashable {
        let type: SectionType
        let options: [Option]
        var selectedOption: Option?

        var title: String {
            type.title
        }
    }

    enum SectionType {
        case status
        case gender

        var title: String {
            switch self {
            case .status: return "Status"
            case .gender: return "Gender"
            }
        }
    }
}

// MARK: - Option

extension FiltersPresentation.Section {
    struct Option: Identifiable, Hashable {
        let id: String
        let title: String
    }
}
