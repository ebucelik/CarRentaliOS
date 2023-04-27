//
//  CarService.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 14.04.23.
//

import Foundation
import ComposableArchitecture

protocol CarServiceProtocol {
    func getAvailableCars(currentCurrency: String,
                          chosenCurrency: String,
                          startDate: String,
                          endDate: String) async throws -> [Car]
}

class CarService: APIClient, CarServiceProtocol {
    func getAvailableCars(currentCurrency: String,
                          chosenCurrency: String,
                          startDate: String,
                          endDate: String) async throws -> [Car] {
        let availableCarsCall = AvailableCarsCall(
            parameters: [
                "currentCurrency": currentCurrency,
                "chosenCurrency": chosenCurrency,
                "from": startDate,
                "to": endDate
            ]
        )

        return try await start(call: availableCarsCall)
    }
}

extension CarService: DependencyKey {
    static let liveValue: CarService = CarService()
    static let testValue: CarService = CarServiceMock()
}

class CarServiceMock: CarService {
    override func getAvailableCars(
        currentCurrency: String,
        chosenCurrency: String,
        startDate: String,
        endDate: String) async throws -> [Car] {
        return [.mock1, .mock2, .mock3]
    }
}
