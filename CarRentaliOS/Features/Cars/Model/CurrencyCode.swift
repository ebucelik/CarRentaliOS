//
//  CurrencyCode.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 16.04.23.
//

import Foundation

struct CurrencyCode: Codable, Equatable, Hashable {
    let currencyCodes: [String]
}

extension CurrencyCode {
    static var mock: CurrencyCode {
        CurrencyCode(
            currencyCodes: [
                "USD",
                "JPY",
                "BGN",
                "CZK",
                "DKK",
                "GBP",
                "HUF",
                "PLN",
                "RON",
                "SEK",
                "CHF",
                "ISK",
                "NOK",
                "TRY",
                "AUD",
                "BRL",
                "CAD",
                "CNY",
                "HKD",
                "IDR",
                "ILS",
                "INR",
                "KRW",
                "MXN",
                "MYR",
                "NZD",
                "PHP",
                "SGD",
                "THB",
                "ZAR"
            ]
        )
    }

    static var mockWithEur: CurrencyCode {
        CurrencyCode(
            currencyCodes: [
                "EUR",
                "USD",
                "JPY",
                "BGN",
                "CZK",
                "DKK",
                "GBP",
                "HUF",
                "PLN",
                "RON",
                "SEK",
                "CHF",
                "ISK",
                "NOK",
                "TRY",
                "AUD",
                "BRL",
                "CAD",
                "CNY",
                "HKD",
                "IDR",
                "ILS",
                "INR",
                "KRW",
                "MXN",
                "MYR",
                "NZD",
                "PHP",
                "SGD",
                "THB",
                "ZAR"
            ]
        )
    }
}
