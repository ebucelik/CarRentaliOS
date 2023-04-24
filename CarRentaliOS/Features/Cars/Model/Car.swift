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
    let totalCosts: Float?
}

extension Car {
    static var emptyCar: Car {
        Car(
            id: 0,
            dailyCost: 0.0,
            brand: "",
            model: "",
            hp: "",
            buildDate: "",
            fuelType: "",
            imageLink: "",
            totalCosts: 0.0
        )
    }
}
