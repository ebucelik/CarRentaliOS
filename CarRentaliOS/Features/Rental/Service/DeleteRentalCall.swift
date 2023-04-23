//
//  DeleteRentalCall.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 23.04.23.
//

import Foundation

struct DeleteRentalCall: Call {
    var responseType = Empty.self
    var httpQuery: String = "booking"
    var httpMethod: HTTPMethod = .DELETE

    init(id: Int) {
        self.httpQuery.append("/\(id)")
    }
}
