import Foundation
import Combine

class CharacterRowViewModel: ObservableObject {
    var database = DatabaseService()
    let character: FavCharacter
    @Published var selectedCharacter: FavCharacter?
    @Published var isFavorited: Bool = false
    var favoritePublisher = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(characterId: String, character: FavCharacter?) {
        self.character = character!
            fetchFavorites(characterId: characterId)
            favoritePublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.isFavorited, on: self)
                .store(in: &cancellables)
    }

    func fetchFavorites(characterId: String) {
        let favorites = database.fetchAllFavorites()
        isFavorited = favorites.contains { $0.id == characterId }
    }

    func toggleFav(character: FavCharacter) {
        database.toggleFavorite(character: character)
        favoritePublisher.send(!isFavorited)
    }

    func determineStatusInfo(_ status: String?) -> (String) {
        switch status {
        case "Alive":
            return ("🍀")
        case "Dead":
            return ("☠️")
        default:
            return ("?")
        }
    }
}
