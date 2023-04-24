//
//  AvailableCarsCall.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 14.04.23.
//

import Foundation

struct AvailableCarsCall: Call {
    var responseType = [Car].self
    var httpQuery: String = "cars"
    var httpMethod: HTTPMethod = .GET
    var parameters: [String : Any]?

    init(parameters: [String : String]) {
        self.parameters = parameters
    }
}
