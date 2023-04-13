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
    var eMail: String
    var password: String
    var phoneNumber: String
    var dateOfBirth: String
}

extension Customer {
    static var emptyCustomer: Customer {
        Customer(
            firstName: "",
            lastName: "",
            eMail: "",
            password: "",
            phoneNumber: "",
            dateOfBirth: ""
        )
    }
}
