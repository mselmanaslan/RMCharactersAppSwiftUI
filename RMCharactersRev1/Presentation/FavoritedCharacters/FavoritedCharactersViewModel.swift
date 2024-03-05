import Foundation
import Combine

class FavoritedCharactersViewModel: ObservableObject {

    private let databaseService = DatabaseService()
    @Published var selectedCharacter: FavCharacter?
    @Published var isFilterMenuOpen = false
    @Published var filterName: String = ""
    @Published var filterSpecies: String = ""
    @Published var filterStatus: String = ""
    @Published var filterGender: String = ""
    @Published var isDetailsViewOpen = false
    @Published var characters: [FavCharacter] = []

    func fetchFavoriteCharacters() {
        self.characters.removeAll()
        self.characters = databaseService.fetchAllFavorites()
    }
}
