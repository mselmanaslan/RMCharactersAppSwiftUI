import Foundation
import SwiftUI
import Combine

final class CharacterRowViewModel: ObservableObject {
    private var database = DatabaseService()
    let character: DbCharacter
    @Published var selectedCharacter: DbCharacter?
    @Published var isFavorited: Bool = false
    var favoritePublisher = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()
    @Published var onFavoriteButtonTapped: VoidClosure

    init(characterId: String, character: DbCharacter?, onFavoriteButtonTapped: @escaping VoidClosure ) {
        self.character = character!
        self.onFavoriteButtonTapped = onFavoriteButtonTapped
        isCharacterInFavorites(characterId: characterId)
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

    var statusInfo: String {
        return "\(determineStatusInfo(character.status)) \(character.name)"
    }

    var statusColor: Color {
        return characterStatusColor(character.status)
    }

    var genderColor: Color {
        return characterGenderColor(character.gender)
    }

    private func isCharacterInFavorites(characterId: String) {
        isFavorited = database.isCharacterInFavorites(characterId: characterId)
    }

    private func toggleFav(character: DbCharacter) {
        database.toggleFavorite(character: character)
        favoritePublisher.send(!isFavorited)
    }

    private func determineStatusInfo(_ status: String?) -> (String) {
        switch status {
        case "Alive":
            return ("🍀")
        case "Dead":
            return ("☠️")
        default:
            return ("?")
        }
    }

    private func characterStatusColor(_ status: String?) -> (Color) {
        switch status {
        case "Alive":
            return .green
        case "Dead":
            return .red
        default:
            return .black
        }
    }

    private func characterGenderColor(_ gender: String?) -> (Color) {
        switch gender {
        case "Male":
            return .blue
        case "Female":
            return .red
        case "Genderless":
            return .purple
        default:
            return .black
        }
    }
}
