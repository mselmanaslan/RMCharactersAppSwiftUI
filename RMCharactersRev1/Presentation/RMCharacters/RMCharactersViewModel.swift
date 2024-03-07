import Foundation
class RMCharactersViewModel: ObservableObject {
    private let characterService = CharacterService()

    @Published var favCharacters: [DbCharacter] = []
    @Published var filteredCharacters: [DbCharacter] = []
    @Published var selectedCharacter: DbCharacter?
    @Published var favoriteIconTapped = false
    @Published var isFilterMenuOpen = false
    @Published var filterName: String = ""
    @Published var filterSpecies: String = ""
    @Published var filterStatus: String = ""
    @Published var filterGender: String = ""
    @Published var isDetailsViewOpen = false

    init() {
        fetchCharacters {
        }
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
            // Karakterlerin her birini favori karakterlere dönüştür
            let favCharacters = characters.map { character in
                return character.getFavCharacter()
            }
            // Dönüştürülmüş karakterleri filtrelenmiş karakter listesine ekle
            self.filteredCharacters.append(contentsOf: favCharacters)
            // Tamamlandı bildirimi
            completion()
        }
    }

    func fetchCharacters(completion: @escaping () -> Void) {
        characterService.fetchCharacters { characters in
            // Karakterlerin her birini favori karakterlere dönüştür
            let favCharacters = characters.map { character in
                return character.getFavCharacter()
            }
            // Dönüştürülmüş karakterleri karakter listesine ekle
            self.favCharacters.append(contentsOf: favCharacters)
            // Tamamlandı bildirimi
            completion()
            // Karakter sayısını yazdır
            print(favCharacters.count)
        }
    }
}
