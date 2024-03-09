//
//  CustomListViewModel.swift
//  RMCharactersRev1
//
//  Created by Selman Aslan on 6.03.2024.
//

import Foundation
import Combine

class CustomListViewModel: ObservableObject {
    @Published var selectedCharacter: DbCharacter?
    @Published var isListEmpty: Bool = false
    @Published var filter = Filter(name: "", status: "", species: "", gender: "")
    @Published var characters: [DbCharacter] = []
    @Published var onFavoriteButtonTapped: () -> Void
    @Published var onTapGestureTapped: (DbCharacter) -> Void
    @Published var isLastCharacter: () -> Void
    @Published var isLastFilteredCharacter: () -> Void
    @Published var isListFiltered: Bool

    var selectedList: [DbCharacter] {
        return isListFiltered ? filteredCharacters : characters
    }

    var filteredCharacters: [DbCharacter] {
        return characters.filter { character in
            let nameMatch = filter.name.isEmpty || character.name.localizedCaseInsensitiveContains(filter.name)
            let statusMatch = filter.status.isEmpty || character.status == filter.status
            let speciesMatch = filter.species.isEmpty || character.species.localizedCaseInsensitiveContains(filter.species)
            let genderMatch = filter.gender.isEmpty || character.gender == filter.gender
            return nameMatch && statusMatch && speciesMatch && genderMatch
        }
    }

    init( filter: Filter,
          isListFiltered: Bool,
          characters: [DbCharacter],
          onFavoriteButtonTapped: @escaping () -> Void,
          onTapGestureTapped: @escaping (DbCharacter) -> Void,
          isLastCharacter: @escaping () -> Void,
          isLastFilteredCharacter: @escaping () -> Void) {
        self.filter = filter
        self.isListFiltered = isListFiltered
        self.characters = characters
        self.onFavoriteButtonTapped = onFavoriteButtonTapped
        self.onTapGestureTapped = onTapGestureTapped
        self.isLastCharacter = isLastCharacter
        self.isLastFilteredCharacter = isLastFilteredCharacter
    }

    func isLastCharacter(_ character: DbCharacter) -> Bool {
         if let lastCharacter = characters.last, lastCharacter.id == character.id {
             return true
         }
         return false
     }
}
