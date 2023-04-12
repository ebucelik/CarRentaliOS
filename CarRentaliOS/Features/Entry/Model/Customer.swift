//
//  Customer.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 23.03.23.
//

import Foundation

struct Customer: Codable, Equatable {
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    var phoneNumber: String
    var dateOfBirth: String
}

extension Customer {
    static var emptyCustomer: Customer {
        Customer(
            firstName: "",
            lastName: "",
            email: "",
            password: "",
            phoneNumber: "",
            dateOfBirth: ""
        )
    }
}
