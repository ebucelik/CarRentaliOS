//
//  Car.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 14.04.23.
//

import Foundation

struct Car: Codable, Equatable, Hashable {
    let id: Int
    let dailyCost: Float
    let brand: String
    let model: String
    let hp: String
    let buildDate: String // "2023-05-22"
    let fuelType: String
    let imageLink: String
    let totalCosts: Float
}
