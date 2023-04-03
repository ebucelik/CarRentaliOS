//
//  String+Extensions.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 23.03.23.
//

import Foundation
import CryptoKit

extension String {
    var hash: String {
        let data = Data(self.utf8)

        return SHA256.hash(data: data).description
    }
}
