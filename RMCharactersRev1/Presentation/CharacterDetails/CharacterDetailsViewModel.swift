import Foundation
import SwiftUI
import Combine

class CharacterDetailsViewModel: ObservableObject {
    var database = DatabaseService()
    let character: FavCharacter

    @Published var isFavorited: Bool = false
    var favoritePublisher = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(character: FavCharacter?) {
        guard let character = character else {
            fatalError("Character is nil")
        }
        self.character = character
        fetchFavorites(characterId: String(character.id))
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

    func determineStatusInfo(_ status: String?) -> DetailsDesign {
        switch status {
        case "Alive":
            return DetailsDesign(bgColor: .green, emote: "🕊️")
        case "Dead":
            return DetailsDesign(bgColor: .red, emote: "☠️")
        default:
            return DetailsDesign(bgColor: .black, emote: "❔")
        }
    }
}
