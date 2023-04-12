//
//  LoginServiceProtocol.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 13.04.23.
//

import Foundation
import ComposableArchitecture

protocol LoginServiceProtocol {
    func login(loginCustomer: LoginCustomer) async throws -> Token
}

class LoginService: APIClient, LoginServiceProtocol {
    func login(loginCustomer: LoginCustomer) async throws -> Token {
        let loginCall = LoginCall(body: loginCustomer)

        return try await start(call: loginCall)
    }
}

extension LoginService: DependencyKey {
    static let liveValue: LoginService = LoginService()
}
