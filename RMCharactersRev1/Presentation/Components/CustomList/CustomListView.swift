//
//  CustomListView.swift
//  RMCharactersRev1
//
//  Created by Selman Aslan on 6.03.2024.
//

import SwiftUI

struct CustomListView: View {
    @ObservedObject var viewModel: CustomListViewModel
    @State var showText = false

    var body: some View {
        if viewModel.selectedList.isEmpty {
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
                List(viewModel.selectedList, id: \.id) { character in
                    CharacterRow(viewModel: CharacterRowViewModel(
                        characterId: String(character.id),
                        character: character),
                                 onFavoriteButtonTapped: {
                        viewModel.onFavoriteButtonTapped()
                    })
                    .onTapGesture {
                        viewModel.selectedCharacter = character
                        viewModel.onTapGestureTapped(character)
                    }
                    .onAppear {
                        if viewModel.isLastCharacter(character) {
                            viewModel.isLastCharacter()
                            viewModel.isLastFilteredCharacter()
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
