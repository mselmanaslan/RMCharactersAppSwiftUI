struct CharacterResponse: Codable {
   let results: [ApiCharacter]
}

struct ApiCharacter: Codable, Identifiable {
    let id: Int
    var name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Origin
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String

    func getFavCharacter() -> DbCharacter {
        return DbCharacter(
            id: String(self.id),
            name: self.name,
            image: self.image,
            status: self.status,
            species: self.species,
            gender: self.gender,
            origin: self.origin.name,
            location: self.location.name,
            episode: self.episode.count)
    }
}

struct Origin: Codable {
    let name: String
    let url: String
}

struct Location: Codable {
    let name: String
    let url: String
}

struct Episode: Codable {
    let name: String
    let episode: String
}
