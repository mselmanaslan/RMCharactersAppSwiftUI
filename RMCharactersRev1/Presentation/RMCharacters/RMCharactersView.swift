import SwiftUI

struct RMCharactersView: View {
    @ObservedObject var viewModel = RMCharactersViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                header
                    .onAppear {
                        viewModel.favoriteIconTapped.toggle()
                    }
                if viewModel.isFilterMenuOpen {
                    filterMenu
                } else {
                    filterButtons
                }
                if viewModel.filterName.isEmpty && viewModel.filterSpecies.isEmpty &&
                    viewModel.filterStatus.isEmpty && viewModel.filterGender.isEmpty {
                    CustomListView(viewModel: CustomListViewModel(
                        filterName: viewModel.filterName,
                        filterSpecies: viewModel.filterSpecies,
                        filterStatus: viewModel.filterStatus,
                        filterGender: viewModel.filterGender,
                        characters: viewModel.favCharacters),
                                   onFavoriteButtonTapped: {},
                                   onTapGestureTapped: {character in
                        viewModel.selectedCharacter = character
                        viewModel.isDetailsViewOpen.toggle()},
                                   isLastCharacter: {
                        viewModel.fetchCharacters {
                            print(viewModel.filteredCharacters.count)
                        }
                    },
                                   isLastFilteredCharacter: {})
                } else {
                    CustomListView(viewModel: CustomListViewModel(
                        filterName: viewModel.filterName,
                        filterSpecies: viewModel.filterSpecies,
                        filterStatus: viewModel.filterStatus,
                        filterGender: viewModel.filterGender,
                        characters: viewModel.filteredCharacters),
                                   onFavoriteButtonTapped: {},
                                   onTapGestureTapped: {character in
                        viewModel.selectedCharacter = character
                        viewModel.isDetailsViewOpen.toggle()},
                                   isLastCharacter: {},
                                   isLastFilteredCharacter: {
                        viewModel.fetchFilteredCharacters {
                            print(viewModel.filteredCharacters.count)
                        }
                    })
                    .onChange(of: viewModel.filterName) { _ in
                        viewModel.updateFilteredCharacters()
                    }
                    .onChange(of: viewModel.filterSpecies) { _ in
                        viewModel.updateFilteredCharacters()
                    }
                    .onChange(of: viewModel.filterStatus) { _ in
                        viewModel.updateFilteredCharacters()
                    }
                    .onChange(of: viewModel.filterGender) { _ in
                        viewModel.updateFilteredCharacters()
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isDetailsViewOpen) {
            CharacterDetailsView(viewModel: CharacterDetailsViewModel(character: viewModel.selectedCharacter),
                                 onFavoriteButtonTapped: {}
            )
        }
    }

    private var header: some View {
        HStack {
            Text("Rick&Morty \nCharacters")
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

struct RMCharactersView_Previews: PreviewProvider {
    static var previews: some View {
        RMCharactersView()
    }
}
