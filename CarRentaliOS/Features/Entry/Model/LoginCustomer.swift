//
//  LoginCustomer.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 13.04.23.
//

import Foundation

struct LoginCustomer: Codable, Equatable {
    var email: String
    var password: String
}

extension LoginCustomer {
    static var emptyLoginCustomer: LoginCustomer {
        LoginCustomer(
            email: "",
            password: ""
        )
    }
}
