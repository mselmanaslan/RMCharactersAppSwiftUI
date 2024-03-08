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
    @Published var filterName: String = ""
    @Published var filterSpecies: String = ""
    @Published var filterStatus: String = ""
    @Published var filterGender: String = ""
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
            let nameMatch = filterName.isEmpty || character.name.localizedCaseInsensitiveContains(filterName)
            let statusMatch = filterStatus.isEmpty || character.status == filterStatus
            let speciesMatch = filterSpecies.isEmpty || character.species.localizedCaseInsensitiveContains(filterSpecies)
            let genderMatch = filterGender.isEmpty || character.gender == filterGender
            return nameMatch && statusMatch && speciesMatch && genderMatch
        }
    }

    init( filterName: String,
          filterSpecies: String,
          filterStatus: String,
          filterGender: String,
          isListFiltered: Bool,
          characters: [DbCharacter],
          onFavoriteButtonTapped: @escaping () -> Void,
          onTapGestureTapped: @escaping (DbCharacter) -> Void,
          isLastCharacter: @escaping () -> Void,
          isLastFilteredCharacter: @escaping () -> Void) {
        self.filterName = filterName
        self.filterSpecies = filterSpecies
        self.filterStatus = filterStatus
        self.filterGender = filterGender
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
