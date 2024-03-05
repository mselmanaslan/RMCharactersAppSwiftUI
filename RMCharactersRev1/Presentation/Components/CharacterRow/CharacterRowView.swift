import SwiftUI

struct CharacterRow: View {
    @ObservedObject var viewModel: CharacterRowViewModel
    var onFavoriteButtonTapped: () -> Void
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(viewModel.determineStatusInfo(viewModel.character.status)) \(viewModel.character.name)")
                        .font(.headline)
                        .bold()
                        .foregroundColor(viewModel.character.status == "Dead" ? .red :
                                            (viewModel.character.status == "Alive" ? .green : .black))
                }
                Spacer()
                FavoriteIconView(viewModel: FavoriteIconViewModel(isFavorited: viewModel.isFavorited,
                    favoriteIconAction: {
                        viewModel.toggleFav(character: viewModel.character)
                        onFavoriteButtonTapped()
                }))
            }
            HStack(alignment: .bottom) {
                if let imageURL = URL(string: viewModel.character.image) {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(
                                        Color(viewModel.character.status == "Alive" ? .green :
                                                (viewModel.character.status == "Dead" ? .red : .black)),
                                        lineWidth: 6
                                    )
                            )
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 115, height: 115)
                    .clipShape(Circle())
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text("Species:")
                            .padding(.top)
                        Text(viewModel.character.species)
                            .bold()
                            .padding(.top)
                    }
                    HStack {
                        Text("Gender:")
                            .padding(.top)
                        Text("\(viewModel.character.gender)")
                            .padding(.top)
                            .bold()
                            .foregroundColor(viewModel.character.gender == "Male" ? .blue :
                                                (viewModel.character.gender == "Female" ? .red :
                                                    (viewModel.character.gender == "Genderless" ? .purple : .black)))
                    }
                    Spacer()
                }
                .padding(.leading)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color(viewModel.character.status == "Dead" ? .red :
                                (viewModel.character.status == "Alive" ? .green : .black)), radius: 5)
    }
}
