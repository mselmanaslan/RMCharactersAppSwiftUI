import Foundation

struct DbCharacter: Codable, Identifiable {
    let id: String
    let name: String
    let image: String
    let status: String
    let species: String
    let gender: String
    let origin: String
    let location: String
    let episode: Int
}
