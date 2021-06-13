import Foundation

// MARK: - Character

struct LocationListResponse: Decodable {
    let info: Info
    let results: [Result]
}

// MARK: - Info

struct Info: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

// MARK: - Result

struct Result: Decodable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [URL]
    let url: String
    let created: String
}
