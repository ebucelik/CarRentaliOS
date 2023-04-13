//
//  RegistrationCustomer.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 13.04.23.
//

import Foundation

struct RegistrationCustomer: Codable, Equatable {
    let id: Int
    let email: String
}

extension RegistrationCustomer {
    static var emptyRegistrationCustomer: RegistrationCustomer {
        RegistrationCustomer(
            id: 0,
            email: ""
        )
    }
}
