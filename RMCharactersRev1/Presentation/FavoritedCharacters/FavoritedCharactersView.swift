import SwiftUI

struct FavoritedCharactersView: View {
    @ObservedObject var viewModel = FavoritedCharactersViewModel()
    var body: some View {
        NavigationView {
            VStack {
                HeaderView(viewModel: viewModel.headerViewModel)
                FilterMenuView(viewModel: viewModel.filterViewModel)
                if viewModel.characters.isEmpty {
                    emptyListText
                } else {
                    CustomListView(viewModel: viewModel.listViewModel)
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

    private var emptyListText: some View {
        VStack(alignment: .center) {
            Spacer()
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
            Spacer()
        }
    }

}

struct FavoritedCharactersView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritedCharactersView()
    }
}
