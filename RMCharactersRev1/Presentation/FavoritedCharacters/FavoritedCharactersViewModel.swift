import Foundation
import Combine

final class FavoritedCharactersViewModel: ObservableObject {

    private let databaseService = DatabaseService()
    @Published var selectedCharacter: DbCharacter?
    @Published var isFilterMenuOpen = false
    @Published var filter = Filter(name: "", status: "", species: "", gender: "")
    @Published var isDetailsViewOpen = false
    @Published var characters: [DbCharacter] = []

    var headerViewModel: HeaderViewModel {
        return HeaderViewModel(
            isFilterMenuOpen: {
                self.isFilterMenuOpen.toggle()
            }, headerTitle: ("Favorite \nCharacters")
        )
    }

    var filterViewModel: FilterMenuViewModel {
        return FilterMenuViewModel(isFilterMenuOpen: isFilterMenuOpen, filter: filter, setFilterParameters: { input in
            self.filter = input
        })
    }

    var detailsViewModel: CharacterDetailsViewModel {
        return CharacterDetailsViewModel(
            character: selectedCharacter,
            onFavoriteButtonTapped: {
            })
    }

    var listViewModel: CustomListViewModel {
        return CustomListViewModel(
            filter: filter,
            isListFiltered: true,
            characters: characters,
            onFavoriteButtonTapped: {
                self.fetchFavoriteCharacters()
            },
            onChracterDetailsButtonTapped: { [weak self] character in
                self?.selectedCharacter = character
                self?.isDetailsViewOpen.toggle()
            },
            isLastCharacter: {})
    }

    func fetchFavoriteCharacters() {
        self.characters.removeAll()
        self.characters = databaseService.fetchAllFavorites()
    }
}
