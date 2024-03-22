struct CharacterResponse: Codable {
    let results: [ApiCharacter]
}

struct ApiCharacter: Codable, Identifiable {
    let id: Int
    let name: String?
    let status: String?
    let species: String?
    let type: String?
    let gender: String?
    let origin: Origin?
    let location: Location?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?

    func getFavCharacter() -> DbCharacter {
        return DbCharacter(
            id: String(self.id),
            name: self.name ?? "N/A",
            image: self.image ?? "N/A",
            status: self.status ?? "N/A",
            species: self.species ?? "N/A",
            gender: self.gender ?? "N/A",
            origin: self.origin?.name ?? "N/A",
            location: self.location?.name ?? "N/A",
            episode: self.episode?.count ?? 0)
    }
}

struct Origin: Codable {
    let name: String?
    let url: String?
}

struct Location: Codable {
    let name: String?
    let url: String?
}

struct Episode: Codable {
    let name: String?
    let episode: String?
}
