import Foundation

// MARK: - Character

struct CharacterListResponse: Decodable {
    let info: Info
    let results: [Result]
}

// MARK: - Info

extension CharacterListResponse {
    struct Info: Decodable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}

// MARK: - Result

extension CharacterListResponse {
    struct Result: Decodable {
        let id: Int
        let name: String
        let status: Status
        let species: String
        let type: String
        let gender: Gender
        let origin: Location
        let location: Location
        let image: String
        let episode: [String]
        let url: String
        let created: String
    }
}

// MARK: - Gender

extension CharacterListResponse.Result {
    enum Gender: String, Decodable {
        case female = "Female"
        case male = "Male"
        case genderless = "Genderless"
        case unknown
    }
}

// MARK: - Location

extension CharacterListResponse.Result {
    struct Location: Decodable {
        let name: String
        let url: String
    }
}

// MARK: - Status

extension CharacterListResponse.Result {
    enum Status: String, Decodable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown
    }
}
