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

    static var mock1: Car {
        Car(
            id: 1,
            dailyCost: 120.0,
            brand: "Mercedes",
            model: "CLA 180",
            hp: "122",
            buildDate: "2023-01-02",
            fuelType: "Diesel",
            imageLink: "",
            totalCosts: 1000.0
        )
    }

    static var mock2: Car {
        Car(
            id: 2,
            dailyCost: 125.0,
            brand: "BMW",
            model: "M4",
            hp: "150",
            buildDate: "2023-02-02",
            fuelType: "Gasolin",
            imageLink: "",
            totalCosts: 1200.0
        )
    }

    static var mock3: Car {
        Car(
            id: 3,
            dailyCost: 99.0,
            brand: "Opel",
            model: "Corsa",
            hp: "67",
            buildDate: "2022-02-02",
            fuelType: "Gasolin",
            imageLink: "",
            totalCosts: 670.0
        )
    }
}
