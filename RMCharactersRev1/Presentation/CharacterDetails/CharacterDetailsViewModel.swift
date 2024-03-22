import Foundation
import SwiftUI
import Combine

final class CharacterDetailsViewModel: ObservableObject {
    private var database = DatabaseService()
    let character: DbCharacter
    var onFavoriteButtonTapped: VoidClosure
    @Published var isFavorited: Bool = false
    private var favoritePublisher = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()

    var detailDesign: DetailsDesign {
        return determineStatusInfo(character.status)
    }

    var statusText: String {
        return ("\(detailDesign.emote) \(character.status)")
    }

    init(character: DbCharacter?, onFavoriteButtonTapped: @escaping VoidClosure) {
        guard let character = character else {
            fatalError("Character is nil")
        }
        self.character = character
        self.onFavoriteButtonTapped = onFavoriteButtonTapped
        fetchFavorites(characterId: String(character.id))
        favoritePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isFavorited, on: self)
            .store(in: &cancellables)
    }

    var favIconViewModel: FavoriteIconViewModel {
        return FavoriteIconViewModel(
            isFavorited: isFavorited,
            favoriteIconAction: {
                self.toggleFav(character: self.character)
                self.onFavoriteButtonTapped()
            }
        )
    }

    private func fetchFavorites(characterId: String) {
        let favorites = database.fetchAllFavorites()
        isFavorited = favorites.contains { $0.id == characterId }
    }

    func toggleFav(character: DbCharacter) {
        database.toggleFavorite(character: character)
        favoritePublisher.send(!isFavorited)
    }

    private func determineStatusInfo(_ status: String?) -> DetailsDesign {
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
