import Foundation

// MARK: - Character

struct EpisodeListResponse: Decodable {
    let info: Info
    let results: [Result]
}

// MARK: - Info

extension EpisodeListResponse {
    struct Info: Decodable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}

// MARK: - Result

extension EpisodeListResponse {
    struct Result: Decodable {
        let id: Int
        let name: String
        let airDate: String
        let episode: String
        let characters: [URL]
        let url: String
        let created: String

        enum CodingKeys: String, CodingKey {
            case id
            case name
            case airDate = "air_date"
            case episode
            case characters
            case url
            case created
        }
    }
}
