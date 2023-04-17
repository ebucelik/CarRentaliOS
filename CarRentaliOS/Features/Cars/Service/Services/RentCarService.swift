//
//  RentCarService.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 17.04.23.
//

import Foundation
import ComposableArchitecture

protocol RentCarServiceProtocol {
    func rentCar(with rentCar: RentCar) async throws -> RentCar
}

class RentCarService: APIClient, RentCarServiceProtocol {
    func rentCar(with rentCar: RentCar) async throws -> RentCar {
        let rentCarCall = RentCarCall(body: rentCar)

        return try await start(call: rentCarCall)
    }
}


extension RentCarService: DependencyKey {
    static let liveValue: RentCarService = RentCarService()
}
