//
//  Date+Extensions.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 17.04.23.
//

import Foundation

extension Date {
    func getStringFormattedDate(_ pattern: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = pattern
        return dateFormatter.string(from: self)
    }
}
