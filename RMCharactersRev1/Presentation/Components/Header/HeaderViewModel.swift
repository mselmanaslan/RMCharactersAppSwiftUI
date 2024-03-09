import Foundation

class HeaderViewModel: ObservableObject {
    @Published var isFilterMenuOpen: () -> Void
    @Published var headerTitle: String

    init(isFilterMenuOpen: @escaping () -> Void, headerTitle: String) {
        self.isFilterMenuOpen = isFilterMenuOpen
        self.headerTitle = headerTitle
    }
}
