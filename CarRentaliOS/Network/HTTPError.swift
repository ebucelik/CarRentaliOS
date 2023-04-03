//
//  HTTPError.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 22.03.23.
//

import Foundation

enum HTTPError: Error {
    case notFound, unauthorized, unexpectedError
}
