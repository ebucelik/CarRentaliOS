//
//  RegisterService.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 13.04.23.
//

import Foundation
import ComposableArchitecture

protocol RegisterServiceProtocol {
    func register(customer: Customer) async throws -> RegistrationCustomer
}

class RegisterService: APIClient, RegisterServiceProtocol {
    func register(customer: Customer) async throws -> RegistrationCustomer {
        let registerCall = RegisterCall(body: customer)

        return try await start(call: registerCall)
    }
}

extension RegisterService: DependencyKey {
    static let liveValue: RegisterService = RegisterService()
}
