//
//  RefreshTokenCall.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 16.04.23.
//

import Foundation

struct RefreshTokenCall: Call {
    var responseType = AccessToken.self
    var httpQuery: String = "customers/auth/refreshtoken"
    var httpMethod: HTTPMethod = .POST
    var body: Codable?

    init(body: RefreshToken) {
        self.body = body
    }
}
