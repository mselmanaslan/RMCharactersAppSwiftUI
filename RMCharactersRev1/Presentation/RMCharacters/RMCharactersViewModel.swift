import Foundation
class RMCharactersViewModel: ObservableObject {
    private let characterService = CharacterService()

    @Published var apiCharacters: [DbCharacter] = []
    @Published var selectedCharacter: DbCharacter?
    @Published var favoriteIconTapped = false
    @Published var isFilterMenuOpen = false
    @Published var filter = Filter(name: "", status: "", species: "", gender: "")
    @Published var isDetailsViewOpen = false
    @Published var filterWorkItem: DispatchWorkItem?
    @Published var isWaiting: Bool = false
    var delayInSeconds: Double = 0

    var filterViewModel: FilterMenuViewModel{
        return FilterMenuViewModel(isFilterMenuOpen: isFilterMenuOpen, filter: filter, setFilterParameters: { input in
            self.filter = input
        })
    }

    var headerViewModel: HeaderViewModel {
            return HeaderViewModel(
                isFilterMenuOpen: {
                    self.isFilterMenuOpen.toggle()
                }, headerTitle: ("Rich&Morty \nCharacters")
            )
        }

    var listViewModel: CustomListViewModel {
            return CustomListViewModel(
                filter: filter,
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
        characterService.fetchCharacters(filter: filter) { characters in
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
