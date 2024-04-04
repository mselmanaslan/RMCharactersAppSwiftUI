import SwiftUI

struct NavigatorTabView: View {
    var body: some View {
        TabView {
            FavoritedCharactersView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .bold()
                }
            RMCharactersView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Characters")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .bold()
                }
        }
    }
}
