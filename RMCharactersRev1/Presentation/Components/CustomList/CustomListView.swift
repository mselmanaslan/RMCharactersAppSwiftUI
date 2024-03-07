//
//  CustomListView.swift
//  RMCharactersRev1
//
//  Created by Selman Aslan on 6.03.2024.
//

import SwiftUI

struct CustomListView: View {
    @ObservedObject var viewModel: CustomListViewModel
    var onFavoriteButtonTapped: () -> Void
    var onTapGestureTapped: (DbCharacter) -> Void
    var isLastCharacter: () -> Void
    var isLastFilteredCharacter: () -> Void
    @State private var showText = false

    var body: some View {
        VStack {
            let filteredCharacters = viewModel.characters.filter { character in
                let nameMatch = viewModel.filterName.isEmpty ||
                character.name.localizedCaseInsensitiveContains(viewModel.filterName)
                let statusMatch = viewModel.filterStatus.isEmpty ||
                character.status == viewModel.filterStatus
                let speciesMatch = viewModel.filterSpecies.isEmpty ||
                character.species.localizedCaseInsensitiveContains(viewModel.filterSpecies)
                let genderMatch = viewModel.filterGender.isEmpty ||
                character.gender == viewModel.filterGender
                return nameMatch && statusMatch && speciesMatch && genderMatch
            }
            if filteredCharacters.isEmpty {
                VStack {
                    if showText {
                        Spacer()
                        Text("Sorry...")
                            .font(.title)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .shadow(color: .black, radius: 0.5)
                            .foregroundColor(.gray)
                        Text("No characters found matching")
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .foregroundColor(.gray)
                        Text("your search criteria.")
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .foregroundColor(.gray)
                        Text("Please try adjusting your filters.")
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .foregroundColor(.gray)
                        Spacer()
                    } else {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showText = true
                    }
                }
            } else {
                List(filteredCharacters, id: \.id) { character in
                    CharacterRow(viewModel: CharacterRowViewModel(
                        characterId: String(character.id),
                        character: character),
                                 onFavoriteButtonTapped: {
                        onFavoriteButtonTapped()
                    })
                    .onTapGesture {
                        viewModel.selectedCharacter = character
                        onTapGestureTapped(character)
                    }
                    .onAppear {
                        if viewModel.isLastCharacter(character) {
                            isLastCharacter()
                            isLastFilteredCharacter()
                            print("sona geldim")
                        }
                        showText = false
                    }
                    .onDisappear {
                        showText = false
                    }
                    .padding(.vertical, 8)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}
