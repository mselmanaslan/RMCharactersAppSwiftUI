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

    init(selectedCharacter: DbCharacter? = nil, 
         filterName: String,
         filterSpecies: String,
         filterStatus: String,
         filterGender: String,
         characters: [DbCharacter]) {
        self.selectedCharacter = selectedCharacter
        self.filterName = filterName
        self.filterSpecies = filterSpecies
        self.filterStatus = filterStatus
        self.filterGender = filterGender
        self.characters = characters
    }

    func isLastCharacter(_ character: DbCharacter) -> Bool {
         if let lastCharacter = characters.last, lastCharacter.id == character.id {
             return true
         }
         return false
     }
}
