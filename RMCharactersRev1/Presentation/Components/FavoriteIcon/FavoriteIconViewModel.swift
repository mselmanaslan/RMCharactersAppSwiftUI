import Foundation

class FavoriteIconViewModel: ObservableObject {

    @Published var isFavorited: Bool
    var favoriteIconAction: (() -> Void)?

    init(isFavorited: Bool, favoriteIconAction: (() -> Void)?) {
        self.isFavorited = isFavorited
        self.favoriteIconAction = favoriteIconAction
    }
}
