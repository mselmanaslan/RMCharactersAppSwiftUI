import SwiftUI

struct CharacterDetailsView: View {

    @ObservedObject var viewModel: CharacterDetailsViewModel

    var body: some View {
        GeometryReader { _ in
            VStack {
                characterImageArea
                    .aspectRatio(contentMode: .fit)
                characterInfoArea
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    private var characterImageArea: some View {
        ZStack {
            characterImage
            characterStatus
            characterName
        }
    }

    private var characterInfoArea: some View {
        VStack {
            HStack {
                characterInfoText(title: "Type:", info: viewModel.character.species)
                Spacer()
                FavoriteIconView(viewModel: viewModel.favIconViewModel)
                    .padding()
            }
            characterInfoText(title: "Gender:", info: viewModel.character.gender)
            characterInfoText(title: "Origin:", info: viewModel.character.origin)
            characterInfoText(title: "Last Seen:", info: viewModel.character.location)
            characterInfoText(title: "Episodes the Character Was Seen In:", info: "\(viewModel.character.episode)")
        }
    }

    private var characterStatus: some View {
        VStack {
            HStack {
                Spacer()
                Text(viewModel.statusText)
                    .font(.title2)
                    .bold()
                    .padding()
                    .foregroundColor(.white)
                    .background(viewModel.detailDesign.bgColor.opacity(1))
                    .clipShape(
                        .rect(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 20,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 0
                        )
                    )
            }
            Spacer()
        }
    }

    private var characterImage: some View {
        VStack {
            if let imageURL = URL(string: viewModel.character.image) {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
            }
        }
    }

    private var characterName: some View {
        VStack {
            Spacer()
            HStack {
                Text(viewModel.character.name)
                    .font(.title2)
                    .bold()
                    .padding()
                    .background(Color.white.opacity(1))
                    .clipShape(
                        .rect(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 30
                        )
                    )
                Spacer()
            }
        }
    }

    private func characterInfoText(title: String, info: String) -> some View {
        return HStack {
            Text(LocalizedStringKey(title))
                .padding([.leading, .top, .bottom])
                .bold()
            Text(LocalizedStringKey(info))
            Spacer()
        }
    }
}
