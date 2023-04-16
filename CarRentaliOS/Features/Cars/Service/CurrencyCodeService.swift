//
//  CurrencyCodeService.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 16.04.23.
//

import Foundation
import ComposableArchitecture

protocol CurrencyCodeServiceProtocol {
    func getCurrencyCodes() async throws -> CurrencyCode
}

class CurrencyCodeService: APIClient, CurrencyCodeServiceProtocol {
    func getCurrencyCodes() async throws -> CurrencyCode {
        let currencyCodeCall = CurrencyCodeCall()

        return try await start(call: currencyCodeCall)
    }
}

extension CurrencyCodeService: DependencyKey {
    static let liveValue: CurrencyCodeService = CurrencyCodeService()
}
