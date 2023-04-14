//
//  AllCarsCall.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 14.04.23.
//

import Foundation

struct AllCarsCall: Call {
    var responseType = [Car].self
    var httpQuery: String = "cars/allCars"
    var httpMethod: HTTPMethod = .GET
    var parameters: [String : Any]?

    init(parameters: [String : String]) {
        self.parameters = parameters
    }
}
