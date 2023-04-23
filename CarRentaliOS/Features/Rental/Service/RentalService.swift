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

    func deleteRental(with id: Int) async throws -> Empty
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

    func deleteRental(with id: Int) async throws -> Empty {
        let deleteRentalCall = DeleteRentalCall(id: id)

        return try await start(call: deleteRentalCall)
    }
}

extension RentalService: DependencyKey {
    static let liveValue: RentalService = RentalService()
}
