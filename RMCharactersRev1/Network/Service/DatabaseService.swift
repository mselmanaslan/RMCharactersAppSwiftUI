import Foundation
import SQLite

class DatabaseService {
    static let shared = DatabaseService()
    private var dbConnection: Connection!
    
    init() {
        do {
            let fileURL = try FileManager.default.url(
                for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("favoritesRev8.sqlite")
            dbConnection = try Connection(fileURL.path)

            if let tableExists =
                try? dbConnection.scalar("SELECT EXISTS (SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = 'favCharacters')")
                as? Int64 {
                if tableExists == 0 {
                    createTable()
                }
            }
        } catch {
            print("Error initializing database: \(error)")
        }
    }

    func toggleFavorite(character: FavCharacter) {
        guard let dbConn = dbConnection else {
            print("Error: Database connection is nil")
            return
        }

        do {
            let query = "SELECT COUNT(*) FROM favCharacters WHERE characterId = ?"
            let count = try dbConn.scalar(query, [character.id]) as? Int64 ?? 0

            if count > 0 {
                removeFavorite(character: character)
            } else {
                addFavorite(character: character)
            }
        } catch {
            print("Error toggling favorite: \(error)")
        }
    }

    private func createTable() {
        do {
            try dbConnection.run("""
                CREATE TABLE IF NOT EXISTS favCharacters (
                    characterId TEXT PRIMARY KEY,
                    name TEXT,
                    image TEXT,
                    status TEXT,
                    species TEXT, -- species sütununu ekleyin
                    gender TEXT,
                    origin TEXT,
                    location TEXT,
                    episodes INTEGER
                )
                """)
        } catch {
            fatalError("Error creating table: \(error)")
        }
    }
    //
    private func addFavorite(character: FavCharacter) {
        do {
            try dbConnection.run("""
                INSERT INTO favCharacters (characterId, name, image, status, species, gender, origin, location, episodes )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ? )
                """, [
                    character.id,
                    character.name,
                    character.image,
                    character.status,
                    character.species,
                    character.gender,
                    character.origin,
                    character.location,
                    character.episode
                ])
            print("Favori ekledim : \(character.name)")
        } catch let error {
            print("Error adding favorite: \(error)")
        }
    }
    private func removeFavorite(character: FavCharacter) {
        do {
            try dbConnection.run("DELETE FROM favCharacters WHERE characterId = ?", [character.id])
            print("Favori çıkardım : \(character.name)")
        } catch let error {
            print("Error removing favorite: \(error)")
        }
    }
    func fetchAllFavorites() -> [FavCharacter] {
        var characters: [FavCharacter] = []
        do {
            let favCharacters = Table("favCharacters")
            let id = Expression<String>("characterId")
            let name = Expression<String>("name")
            let image = Expression<String>("image")
            let status = Expression<String>("status")
            let species = Expression<String>("species")
            let gender = Expression<String>("gender")
            let origin = Expression<String>("origin")
            let location = Expression<String>("location")
            let episode = Expression<Int>("episodes")
            let query = favCharacters.select(id, name, image, status, species, gender, origin, location, episode)

            let charactersFromDB = try dbConnection.prepare(query)
            for character in charactersFromDB {
                let favCharacter = FavCharacter(id: String(character[id]),
                                                name: character[name],
                                                image: character[image],
                                                status: character[status],
                                                species: character[species],
                                                gender: character[gender],
                                                origin: character[origin],
                                                location: character[location],
                                                episode: character[episode])
                characters.append(favCharacter)
            }
        } catch let error {
            print("Error fetching all favorites: \(error)")
        }
        return characters
    }
}
