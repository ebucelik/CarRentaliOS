//
//  RegisterCall.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 13.04.23.
//

import Foundation

struct RegisterCall: Call {
    var responseType = RegistrationCustomer.self
    var httpQuery: String = "customers/auth/registration"
    var httpMethod: HTTPMethod = .POST
    var body: Codable?

    init(body: Customer) {
        self.body = body
    }
}
