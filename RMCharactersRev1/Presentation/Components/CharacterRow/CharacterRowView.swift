import SwiftUI

struct CharacterRow: View {
    @ObservedObject var viewModel: CharacterRowViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(viewModel.statusInfo)
                        .font(.headline)
                        .bold()
                        .foregroundColor(viewModel.statusColor)
                }
                Spacer()
                FavoriteIconView(viewModel: viewModel.favIconViewModel)
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
                                        Color(viewModel.statusColor),
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
                        Text(LocalizedStringKey(viewModel.character.species))
                            .bold()
                            .padding(.top)
                    }
                    HStack {
                        Text("Gender:")
                            .padding(.top)
                        Text(LocalizedStringKey(viewModel.character.gender))
                            .padding(.top)
                            .bold()
                            .foregroundColor(viewModel.genderColor)
                    }
                    Spacer()
                }
                .padding(.leading)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color(viewModel.statusColor), radius: 5)
    }
}
