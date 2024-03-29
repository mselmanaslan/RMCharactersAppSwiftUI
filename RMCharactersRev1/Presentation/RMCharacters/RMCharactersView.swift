import SwiftUI

struct RMCharactersView: View {
    @ObservedObject var viewModel = RMCharactersViewModel()

    var body: some View {
        NavigationView {
            VStack {
                HeaderView(viewModel: viewModel.headerViewModel)
                FilterMenuView(viewModel: viewModel.filterViewModel)
                if viewModel.isWaiting {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    CustomListView(viewModel: viewModel.listViewModel)
                        .onChange(of: viewModel.filter) { _ in
                            viewModel.updateFilteredCharacters()
                        }
                }
            }
        }
        .sheet(isPresented: $viewModel.isDetailsViewOpen) {
            CharacterDetailsView(viewModel: viewModel.detailsViewModel)
        }
    }
}

struct RMCharactersView_Previews: PreviewProvider {
    static var previews: some View {
        RMCharactersView()
    }
}
