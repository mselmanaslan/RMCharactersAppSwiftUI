//
//  FilterMenuViewModel.swift
//  RMCharactersRev1
//
//  Created by Selman Aslan on 9.03.2024.
//

import Foundation

final class FilterMenuViewModel: ObservableObject {
    @Published var isFilterMenuOpen: Bool
    @Published var filter = Filter(name: "", status: "", species: "", gender: "")
    var setFilterParameters: (Filter) -> Void

    init(isFilterMenuOpen: Bool,
         filter: Filter = Filter(name: "", status: "", species: "", gender: ""),
         setFilterParameters: @escaping (Filter) -> Void) {
        self.isFilterMenuOpen = isFilterMenuOpen
        self.filter = filter
        self.setFilterParameters = setFilterParameters
    }
}
