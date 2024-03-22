//
//  ServiceResponse.swift
//  RMCharactersRev1
//
//  Created by Selman Aslan on 15.03.2024.
//

import Foundation

enum ServiceResponse<T> {
    case success(T)
    case error(String)
}
