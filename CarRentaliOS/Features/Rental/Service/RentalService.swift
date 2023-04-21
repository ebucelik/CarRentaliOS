//
//  RentalService.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 21.04.23.
//

import Foundation
import ComposableArchitecture

protocol RentalServiceProtocol {
    func getAllRentals(for currentCurrency: String) async throws -> [Rental]
}

class RentalService: APIClient, RentalServiceProtocol {
    func getAllRentals(for currentCurrency: String) async throws -> [Rental] {
        let rentalCall = RentalCall(
            parameters: [
                "currentCurrency": currentCurrency
            ]
        )

        return try await start(call: rentalCall)
    }
}

extension RentalService: DependencyKey {
    static let liveValue: RentalService = RentalService()
}
