//
//  LoginCall.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 13.04.23.
//

import Foundation

struct LoginCall: Call {
    var responseType: Token.Type = Token.self
    var httpQuery: String = "customers/auth/login"
    var httpMethod: HTTPMethod = .POST
    var body: Codable?

    init(body: LoginCustomer) {
        self.body = body
    }
}
