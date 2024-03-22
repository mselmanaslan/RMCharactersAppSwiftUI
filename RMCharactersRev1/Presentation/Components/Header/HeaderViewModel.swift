import Foundation

final class HeaderViewModel: ObservableObject {
    @Published var isFilterMenuOpen: VoidClosure
    @Published var headerTitle: String

    init(isFilterMenuOpen: @escaping VoidClosure, headerTitle: String) {
        self.isFilterMenuOpen = isFilterMenuOpen
        self.headerTitle = headerTitle
    }
}
