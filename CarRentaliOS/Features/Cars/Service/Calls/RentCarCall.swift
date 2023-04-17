//
//  RentCarCall.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 17.04.23.
//

import Foundation

struct RentCarCall: Call {
    var responseType = RentCar.self
    var httpQuery: String = "booking"
    var httpMethod: HTTPMethod = .POST
    var body: Codable?

    init(body: RentCar) {
        self.body = body
    }
}
