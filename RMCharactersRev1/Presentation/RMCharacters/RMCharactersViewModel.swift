import Foundation
class RMCharactersViewModel: ObservableObject {
    private let characterService = CharacterService()

    @Published var apiCharacters: [DbCharacter] = []
    @Published var selectedCharacter: DbCharacter?
    @Published var favoriteIconTapped = false
    @Published var isFilterMenuOpen = false
    @Published var filterName: String = ""
    @Published var filterSpecies: String = ""
    @Published var filterStatus: String = ""
    @Published var filterGender: String = ""
    @Published var isDetailsViewOpen = false
    @Published var filterWorkItem: DispatchWorkItem?
    @Published var isWaiting: Bool = false
    var delayInSeconds: Double = 0

    var combinedFilters: String {
            return filterName + filterStatus + filterSpecies  + filterGender
        }


    var listViewModel: CustomListViewModel {
            return CustomListViewModel(
                filterName: filterName,
                filterSpecies: filterSpecies,
                filterStatus: filterStatus,
                filterGender: filterGender,
                isListFiltered: false,
                characters: apiCharacters,
                onFavoriteButtonTapped: {
                    self.favoriteIconTapped.toggle()
                },
                onTapGestureTapped: { character in
                    self.selectedCharacter = character
                    self.isDetailsViewOpen.toggle()
                },
                isLastCharacter: {
                },
                isLastFilteredCharacter: {
                    self.fetchCharacters {
                        print(self.apiCharacters.count)
                    }
                }
            )
        }

    init() {
        fetchCharacters {
        }
    }

    func updateFilteredList(){
        isWaiting = true
        delayInSeconds += 1.3
        apiCharacters.removeAll()
        filterWorkItem?.cancel()
        filterWorkItem = DispatchWorkItem {
            self.updateFilteredCharacters()
            print("bekledim")
            self.isWaiting = false
            self.delayInSeconds = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds, execute: filterWorkItem!)
    }

    func updateFilteredCharacters() {
        fetchCharacters {
            print("filtered characters count:")
            print(self.apiCharacters.count)
        }
    }

    func fetchCharacters(completion: @escaping () -> Void) {
        characterService.fetchCharacters(name: filterName,
                                                 status: filterStatus,
                                                 species: filterSpecies,
                                                 gender: filterGender) { characters in
            // Karakterlerin her birini favori karakterlere dönüştür
            let favCharacters = characters.map { character in
                return character.getFavCharacter()
            }
            // Dönüştürülmüş karakterleri filtrelenmiş karakter listesine ekle
            self.apiCharacters.append(contentsOf: favCharacters)
            // Tamamlandı bildirimi
            completion()
        }
    }
}
