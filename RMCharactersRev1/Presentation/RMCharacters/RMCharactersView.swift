import SwiftUI

struct RMCharactersView: View {
    @ObservedObject var viewModel = RMCharactersViewModel()
 
    var body: some View {
        NavigationView {
            VStack {
                HeaderView(viewModel: viewModel.headerViewModel)
                if viewModel.isFilterMenuOpen {
                    filterMenu
                } else {
                    filterButtons
                }
                if viewModel.isWaiting {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    CustomListView(viewModel: viewModel.listViewModel)
                    .onChange(of: viewModel.combinedFilters) { _ in
                        viewModel.updateFilteredList()
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