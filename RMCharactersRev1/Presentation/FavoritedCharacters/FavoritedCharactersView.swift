import SwiftUI

struct FavoritedCharactersView: View {
    @ObservedObject var viewModel = FavoritedCharactersViewModel()
    var body: some View {
        NavigationView {
            VStack {
                header
                if viewModel.isFilterMenuOpen {
                    filterMenu
                } else {
                    filterButtons
                }
                if viewModel.characters.isEmpty {
                    Spacer()
                    VStack(alignment: .center) {
                        Text("Oops...")
                            .font(.title)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .shadow(color: .black, radius: 0.5)
                            .foregroundColor(.gray)
                        Text("It looks like you haven't added")
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .foregroundColor(.gray)
                        Text("any favorite characters yet.")
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    CustomListView(viewModel: viewModel.listViewModel
                    )
                }
            }
            .onAppear {
                viewModel.fetchFavoriteCharacters()
            }
            .sheet(isPresented: $viewModel.isDetailsViewOpen,
                   onDismiss: {
                viewModel.isDetailsViewOpen = false
                viewModel.selectedCharacter = nil
                viewModel.fetchFavoriteCharacters()
            }, content: {
                CharacterDetailsView(viewModel: CharacterDetailsViewModel(character: viewModel.selectedCharacter),
                                     onFavoriteButtonTapped: { }
                )
            })
        }
    }

    private var header: some View {
        HStack {
            Text("Favorite \nCharacters")
                .font(.title)
                .fontWeight(.bold)
                .lineLimit(2)
                .shadow(color: .black, radius: 0.5)
                .foregroundColor(.black)
                .padding(.leading, 20)
            Spacer()
            Button {
                viewModel.isFilterMenuOpen.toggle()
                print("CHVW isFİlterMenuOpen: \(viewModel.isFilterMenuOpen)")
            } label: {
                Text("Filter")
                    .font(.system(size: 26))
                    .bold()
                    .padding()
            }
        }
    }

    private var filterButtons: some View {
        HStack {
            filterButton(for: viewModel.filterName, action: { viewModel.filterName = "" })
            filterButton(for: viewModel.filterStatus, action: { viewModel.filterStatus = "" })
            filterButton(for: viewModel.filterSpecies, action: { viewModel.filterSpecies = "" })
            filterButton(for: viewModel.filterGender, action: { viewModel.filterGender = "" })
            Spacer()
        }
    }

    private func filterButton(for text: String, action: @escaping () -> Void) -> AnyView {
        if !text.isEmpty {
            return AnyView(
                Button(action: action) {
                    HStack {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                        Text(text)
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                    }
                    .frame(width: 75, height: 30)
                    .background(Color.blue)
                    .cornerRadius(25)
                    .padding(.leading)
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }

    private var characterList: some View {
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
        return VStack {
            if filteredCharacters.isEmpty {
                VStack {
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
                }
            } else {
                List(filteredCharacters, id: \.id) { character in
                    CharacterRow(viewModel: CharacterRowViewModel(characterId: String(character.id),
                                                                  character: character),
                                 onFavoriteButtonTapped: {
                        viewModel.fetchFavoriteCharacters()
                    })
                    .onTapGesture {
                        viewModel.selectedCharacter = character
                        viewModel.isDetailsViewOpen.toggle()
                    }
                    .padding(.vertical, 8)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .onAppear {
            viewModel.fetchFavoriteCharacters()
        }
    }

    private var filterMenu: some View {
        VStack {
            HStack {
                Text("Filter By")
                    .padding(.leading)
                    .font(.title)
                    .bold()
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            HStack {
                Text("Name   ")
                    .padding(.leading)
                TextField("Character Name", text: $viewModel.filterName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.black)
            }
            HStack {
                Text("Status")
                    .padding(.leading)
                Spacer()
                Picker("", selection: $viewModel.filterStatus) {
                    Text("All").tag("")
                    Text("Dead").tag("Dead")
                    Text("Alive").tag("Alive")
                    Text("Unknown").tag("unknown")
                }
                .pickerStyle(SegmentedPickerStyle())
                .colorMultiply(.white).colorInvert()
                .colorMultiply(.orange).colorInvert()
            }
            HStack {
                Text("Species")
                    .padding(.leading)
                TextField("Species", text: $viewModel.filterSpecies)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.black)
            }
            HStack {
                Text("Gender")
                    .padding(.leading)
                Spacer()
                Picker("", selection: $viewModel.filterGender) {
                    Text("All").tag("")
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                    Text("Genderless").tag("Genderless")
                    Text("Unknown").tag("unknown")
                }
                .pickerStyle(SegmentedPickerStyle())
                .colorMultiply(.white).colorInvert()
                .colorMultiply(.orange).colorInvert()
            }
        }
    }
}

struct FavoritedCharactersView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritedCharactersView()
    }
}
