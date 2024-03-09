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
    
    var headerViewModel: HeaderViewModel {
            return HeaderViewModel(
                isFilterMenuOpen: {
                    self.isFilterMenuOpen.toggle()
                }, headerTitle: ("Favorite \nCharacters")
            )
        }


    var listViewModel: CustomListViewModel {
            return CustomListViewModel(
                filterName: filterName,
                filterSpecies: filterSpecies,
                filterStatus: filterStatus,
                filterGender: filterGender,
                isListFiltered: true,
                characters: characters,
                onFavoriteButtonTapped: {
                    self.fetchFavoriteCharacters()
                },
                onTapGestureTapped: { character in
                    self.selectedCharacter = character
                    self.isDetailsViewOpen.toggle()
                },
                isLastCharacter: {},
                isLastFilteredCharacter: {})

        }

    func fetchFavoriteCharacters() {
        self.characters.removeAll()
        self.characters = databaseService.fetchAllFavorites()
    }
}
