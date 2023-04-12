//
//  Loadable.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 13.04.23.
//

import Foundation

enum Loadable<T>: Equatable where T: Codable & Equatable {
    case loaded(T)
    case loading
    case error(HTTPError)
    case none
}
