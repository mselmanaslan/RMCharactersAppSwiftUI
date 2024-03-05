import SwiftUI

struct CharacterDetailsView: View {

    @ObservedObject var viewModel: CharacterDetailsViewModel
    var onFavoriteButtonTapped: () -> Void

    var body: some View {
        let detailDesign = viewModel.determineStatusInfo(viewModel.character.status)
        GeometryReader { _ in
            VStack {
                ZStack {
                    if let imageURL = URL(string: viewModel.character.image ) {
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    VStack {
                        HStack {
                            Spacer()
                            Text("\(detailDesign.emote) \(viewModel.character.status)")
                                .font(.title2)
                                .bold()
                                .padding()
                                .foregroundColor(.white)
                                .background(detailDesign.bgColor.opacity(1))
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

                    VStack {
                        Spacer()
                        HStack {
                            Text("\(viewModel.character.name)")
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
                .aspectRatio(contentMode: .fit)
                VStack {
                    HStack {
                        Text("Type:")
                            .padding([.leading, .top, .bottom])
                            .bold()
                        Text("\(viewModel.character.species)")
                        Spacer()
                        FavoriteIconView(viewModel: FavoriteIconViewModel(isFavorited: viewModel.isFavorited,
                            favoriteIconAction: {
                            viewModel.toggleFav(character: viewModel.character)
                            onFavoriteButtonTapped()
                        }))
                            .padding()
                    }
                    HStack {
                        Text("Gender:")
                            .padding([.leading, .top, .bottom])
                            .bold()
                        Text("\(viewModel.character.gender)")
                        Spacer()
                    }
                    HStack {
                        Text("Origin:")
                            .padding([.leading, .top, .bottom])
                            .bold()
                        Text("\(viewModel.character.origin)")
                        Spacer()
                    }
                    HStack {
                        Text("Last Seen:")
                            .padding([.leading, .top, .bottom])
                            .bold()
                        Text("\(viewModel.character.location)")
                        Spacer()
                    }
                    HStack {
                        Text("Episodes the Character Was Seen In:")
                            .padding([.leading, .top, .bottom])
                            .bold()
                        Text("\(viewModel.character.episode)")
                        Spacer()
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
