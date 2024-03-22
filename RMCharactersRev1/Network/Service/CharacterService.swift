import Foundation

final class CharacterService {

    func fetchCharacters(
        filter: Filter,
        pageNumber: Int,
        completion: @escaping (ServiceResponse<[ApiCharacter]>) -> Void
    ) {
        let config = URLSessionConfiguration.default
        config.urlCache = nil
        let session = URLSession(configuration: config)

        guard let url = URLBuilder()
            .setPath("/api/character/")
            .addQueryItem(name: "page", value: String(pageNumber))
            .addQueryItem(name: "name", value: filter.name)
            .addQueryItem(name: "status", value: filter.status)
            .addQueryItem(name: "species", value: filter.species)
            .addQueryItem(name: "gender", value: filter.gender)
            .build()
        else {
            DispatchQueue.main.async {
                completion(.error("Geçersiz URL"))
            }
            return
        }

        session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.error("Hata: \(error.localizedDescription)"))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.error("Geçersiz yanıt"))
                }
                return
            }

            guard let responseData = data else {
                DispatchQueue.main.async {
                    completion(.error("Boş veri"))
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(CharacterApiResponse.self, from: responseData)
                if response.info.pages >= pageNumber {
                    // veriyi çek
                    DispatchQueue.main.async {
                        completion(.success(response.results))
                    }
                } else {
                    print("Sayfa sonu...")
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.error("Veri dönüştürme hatası: \(error.localizedDescription)"))
                }
            }
        }.resume()
    }
}
