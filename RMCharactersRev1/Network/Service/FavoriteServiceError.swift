//
//  FavoriteServiceError.swift
//  RMCharactersRev1
//
//  Created by Selman Aslan on 4.04.2024.
//

import Foundation

enum FavoriteServiceError: Error {
    case databaseConnectionNil
    case tableCreationError
}
