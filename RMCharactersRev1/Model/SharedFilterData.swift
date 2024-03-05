import Foundation

class SharedFilterData: ObservableObject {
    static let shared = SharedFilterData()

    @Published var isFilterMenuOpen = false
    @Published var filterName: String = ""
    @Published var filterSpecies: String = ""
    @Published var filterStatus: String = ""
    @Published var filterGender: String = ""
}
