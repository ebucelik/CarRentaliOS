//
//  Customer.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 23.03.23.
//

import Foundation

struct Customer: Codable, Equatable {
    var firstname: String
    var lastname: String
    var username: String
    var password: String
}

extension Customer {
    static var emptyCustomer: Customer {
        Customer(
            firstname: "",
            lastname: "",
            username: "",
            password: ""
        )
    }
}
