import Foundation
import Combine

class CharacterRowViewModel: ObservableObject {
    var database = DatabaseService()
    let character: DbCharacter
    @Published var selectedCharacter: DbCharacter?
    @Published var isFavorited: Bool = false
    var favoritePublisher = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(characterId: String, character: DbCharacter?) {
        self.character = character!
            isCharacterInFavorites(characterId: characterId)
            favoritePublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.isFavorited, on: self)
                .store(in: &cancellables)
    }

    func isCharacterInFavorites(characterId: String) {
        isFavorited = database.isCharacterInFavorites(characterId: characterId)
    }

    func toggleFav(character: DbCharacter) {
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
