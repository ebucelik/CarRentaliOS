//
//  CarService.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 14.04.23.
//

import Foundation
import ComposableArchitecture

protocol CarServiceProtocol {
    func getAllCars(currency: String) async throws -> [Car]

    func getAvailableCars(currency: String, startDate: String, endDate: String) async throws -> [Car]
}

class CarService: APIClient, CarServiceProtocol {
    func getAllCars(currency: String) async throws -> [Car] {
        let allCarsCall = AllCarsCall(
            parameters: ["currency": currency]
        )

        return try await start(call: allCarsCall)
    }

    func getAvailableCars(currency: String, startDate: String, endDate: String) async throws -> [Car] {
        let availableCarsCall = AvailableCarsCall(
            parameters: [
                "currency": currency,
                "from": startDate,
                "to": endDate
            ]
        )

        return try await start(call: availableCarsCall)
    }
}

extension CarService: DependencyKey {
    static let liveValue: CarService = CarService()
}
