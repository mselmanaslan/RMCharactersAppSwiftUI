import SwiftUI

struct FavoriteIconView: View {
    @ObservedObject var viewModel: FavoriteIconViewModel

    init(viewModel: FavoriteIconViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Button {
            viewModel.favoriteIconAction?()
        } label: {
            Image(systemName: viewModel.isFavorited ? "heart.fill" : "heart")
                .resizable()
                .foregroundColor(viewModel.isFavorited ? .red : .black)
                .frame(width: 26, height: 24)
        }
    }
}
