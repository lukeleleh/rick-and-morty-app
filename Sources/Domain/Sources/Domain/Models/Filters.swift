public struct Filters: Equatable {
    public let status: Character.Status?
    public let gender: Character.Gender?

    public init(status: Character.Status?, gender: Character.Gender?) {
        self.status = status
        self.gender = gender
    }
}

extension Filters {
    public static let `default` = Filters(status: nil, gender: nil)

    public var isDefault: Bool {
        self == .default
    }
}
