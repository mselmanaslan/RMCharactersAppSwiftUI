import Foundation
class RMCharactersViewModel: ObservableObject {
    private let characterService = CharacterService()
    @Published var characters: [Character] = []
    @Published var filteredCharacters: [Character] = []
    @Published var selectedCharacter: FavCharacter?
    @Published var favoriteIconTapped = false
    @Published var isFilterMenuOpen = false
    @Published var isListFiltered: String = ""
    @Published var filterName: String = ""
    @Published var filterSpecies: String = ""
    @Published var filterStatus: String = ""
    @Published var filterGender: String = ""
    @Published var isDetailsViewOpen = false

    init() {
        fetchCharacters {
            print(self.characters.count)
        }
    }

   func isLastCharacter(_ character: Character) -> Bool {
        if let lastCharacter = characters.last, lastCharacter.id == character.id {
            return true
        }
        return false
    }

    func isLastFilteredCharacter(_ character: Character) -> Bool {
        if let lastFilteredCharacter = filteredCharacters.last, lastFilteredCharacter.id == character.id {
            return true
        }
        return false
    }

    func updateFilteredCharacters() {
        filteredCharacters.removeAll()
        fetchFilteredCharacters {
            print("filtered characters count:")
            print(self.filteredCharacters.count)
        }
    }

    func fetchFilteredCharacters(completion: @escaping () -> Void) {
        characterService.fetchFilteredCharacters(name: filterName,
                                                 status: filterStatus,
                                                 species: filterSpecies,
                                                 gender: filterGender) { characters in
            self.filteredCharacters.append(contentsOf: characters)
            completion()
        }
    }

    func fetchCharacters(completion: @escaping () -> Void) {
        characterService.fetchCharacters { characters in
            self.characters.append(contentsOf: characters)
            completion()
            print(characters.count)
        }
    }
    
}
