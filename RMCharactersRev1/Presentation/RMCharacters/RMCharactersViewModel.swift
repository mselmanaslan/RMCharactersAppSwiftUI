import Foundation
import Combine

final class RMCharactersViewModel: ObservableObject {

    private let characterService = CharacterService()
    private var cancellables = Set<AnyCancellable>()
    @Published var apiCharacters: [DbCharacter] = []
    @Published var selectedCharacter: DbCharacter?
    @Published var favoriteIconTapped = false
    @Published var isFilterMenuOpen = false
    @Published var filter = Filter(name: "", status: "", species: "", gender: "")
    @Published var isDetailsViewOpen = false
    @Published var isWaiting: Bool = false
    private var apiPageNumber = 0

    var filterViewModel: FilterMenuViewModel {
        return FilterMenuViewModel(isFilterMenuOpen: isFilterMenuOpen, filter: filter, setFilterParameters: { input in
            self.filter = input
        })
    }

    var headerViewModel: HeaderViewModel {
        return HeaderViewModel(
            isFilterMenuOpen: {
                self.isFilterMenuOpen.toggle()
            }, headerTitle: ("Rick&Morty \nCharacters")
        )
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
            isListFiltered: false,
            characters: apiCharacters,
            onFavoriteButtonTapped: {
                self.favoriteIconTapped.toggle()
            },
            onChracterDetailsButtonTapped: { character in
                self.selectedCharacter = character
                self.isDetailsViewOpen.toggle()
            },
            isLastCharacter: {
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

    func updateFilteredCharacters() {
        self.isWaiting = true
        self.apiPageNumber = 0
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        $filter
            .debounce(for: .seconds(0.6), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.apiCharacters.removeAll()
                self?.fetchCharacters { [weak self] in
                    print("calistim")
                    self?.isWaiting = false
                }
            }
            .store(in: &cancellables)
    }

    func fetchCharacters(completion: @escaping () -> Void) {
        self.apiPageNumber += 1
        characterService.fetchCharacters(filter: filter, pageNumber: apiPageNumber) { [weak self] response in
            switch response {
            case .success(let characters):
                let favCharacters = characters.map { character in
                    return character.getFavCharacter()
                }
                DispatchQueue.main.async {
                    self?.apiCharacters.append(contentsOf: favCharacters)
                    completion()
                }
            case .error(let errorMessage):
                print(errorMessage)
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
}
