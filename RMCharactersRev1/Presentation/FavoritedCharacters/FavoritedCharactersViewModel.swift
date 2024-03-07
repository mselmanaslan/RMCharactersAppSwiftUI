import Foundation
import Combine

class FavoritedCharactersViewModel: ObservableObject {

    private let databaseService = DatabaseService()
    @Published var selectedCharacter: DbCharacter?
    @Published var isFilterMenuOpen = false
    @Published var filterName: String = ""
    @Published var filterSpecies: String = ""
    @Published var filterStatus: String = ""
    @Published var filterGender: String = ""
    @Published var isDetailsViewOpen = false
    @Published var characters: [DbCharacter] = []

    func fetchFavoriteCharacters() {
        self.characters.removeAll()
        self.characters = databaseService.fetchAllFavorites()
    }
}
