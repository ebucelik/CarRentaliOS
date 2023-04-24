//
//  Rental.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 21.04.23.
//

import Foundation

struct Rental: Codable, Equatable {
    let id: Int
    let customerId: Int
    let carId: Int?
    let car: Car?
    let startDay: String
    let endDay: String
    let totalCost: Float
}

extension Rental {
    func carUnwrapped() -> Car {
        car ?? .emptyCar
    }
}
