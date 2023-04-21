//
//  RentalCall.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 21.04.23.
//

import Foundation

struct RentalCall: Call {
    var responseType = [Rental].self
    var httpQuery: String = "allBookings"
    var httpMethod: HTTPMethod = .GET
    var parameters: [String : Any]?

    init(parameters: [String : String]) {
        self.parameters = parameters
    }
}
