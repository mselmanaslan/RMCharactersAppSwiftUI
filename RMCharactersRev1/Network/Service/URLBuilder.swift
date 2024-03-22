//
//  URLBuilder.swift
//  RMCharactersRev1
//
//  Created by Selman Aslan on 17.03.2024.
//

import Foundation

final class URLBuilder {
    private var scheme: String = "https"
    private var host: String = "rickandmortyapi.com"
    private var path: String = "/api/character/"
    private var queryItems: [URLQueryItem] = []

    func setScheme(_ scheme: String) -> URLBuilder {
        self.scheme = scheme
        return self
    }

    func setHost(_ host: String) -> URLBuilder {
        self.host = host
        return self
    }

    func setPath(_ path: String) -> URLBuilder {
        self.path = path
        return self
    }

    func addQueryItem(name: String, value: String?) -> URLBuilder {
        let queryItem = URLQueryItem(name: name, value: value)
        queryItems.append(queryItem)
        return self
    }

    func build() -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        print(components.url ?? "err")
        return components.url
    }
}
