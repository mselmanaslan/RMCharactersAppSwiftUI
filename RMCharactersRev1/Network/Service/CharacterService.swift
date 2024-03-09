import Foundation

class CharacterService {
    private var pageNumber = 1
    private var fetchLastPage = 1
    var prevName: String?
    var prevStatus: String?
    var prevSpecies: String?
    var prevGender: String?

    func fetchCharacters(
        name: String,
        status: String,
        species: String,
        gender: String,
        completion: @escaping ([ApiCharacter]) -> Void
    ) {
            if name != prevName || status != prevStatus || species != prevSpecies || gender != prevGender {
                // Eğer herhangi bir filtre değiştiyse, sayfa numarasını sıfırla
                pageNumber = 1
            }

        guard let url = URL(
            string: "https://rickandmortyapi.com/api/character/?page=\(pageNumber)&name=\(name)&status=\(status)&species=\(species)&gender=\(gender)")
        else {
            print("Geçersiz URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Hata: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Geçersiz yanıt")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }

            guard let responseData = data else {
                print("Boş veri")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ApiResponse.self, from: responseData)
                DispatchQueue.main.async {
                    // response.info.pages > filteredPageNumber kontrolü
                    if response.info.pages > self.pageNumber {
                        // veriyi çek ve page numberi bir arttır
                        completion(response.results)
                        self.pageNumber += 1
                    } else if response.info.pages == self.pageNumber {
                        // son sayfa veriyi çek ve page numberi bir arttır hatalı url döndürsün artık
                        completion(response.results)
                        self.pageNumber += 1
                    } else {
                        print("Sayfa sonu...")
                    }
                }
            } catch {
                print("Veri dönüştürme hatası: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
        // Dışarıdan alınan filtre değişkenlerini güncelle
        prevName = name
        prevStatus = status
        prevSpecies = species
        prevGender = gender
    }
}