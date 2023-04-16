//
//  CurrencyCodeCall.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 16.04.23.
//

import Foundation

struct CurrencyCodeCall: Call {
    var responseType = CurrencyCode.self
    var httpQuery: String = "currency/currencyCodes"
    var httpMethod: HTTPMethod = .GET
}
