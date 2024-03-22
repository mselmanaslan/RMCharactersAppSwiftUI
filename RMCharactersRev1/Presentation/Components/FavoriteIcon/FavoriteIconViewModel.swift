import Foundation

final class FavoriteIconViewModel: ObservableObject {

    @Published var isFavorited: Bool
    var favoriteIconAction: (VoidClosure)?

    init(isFavorited: Bool, favoriteIconAction: (VoidClosure)?) {
        self.isFavorited = isFavorited
        self.favoriteIconAction = favoriteIconAction
    }
}
