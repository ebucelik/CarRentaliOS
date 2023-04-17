//
//  RentCar.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 17.04.23.
//

import Foundation

struct RentCar: Codable, Equatable {
    let carId: Int
    let startDay: String
    let endDay: String
    let totalCost: Float
    let currentCurrency: String?
    let email: String?
}
