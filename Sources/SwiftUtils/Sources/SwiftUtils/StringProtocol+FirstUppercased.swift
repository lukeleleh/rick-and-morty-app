public extension StringProtocol {
    var firstUppercased: String {
        prefix(1).uppercased() + dropFirst()
    }
}
