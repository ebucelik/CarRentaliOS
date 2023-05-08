//
//  Call.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 22.03.23.
//

import Foundation

public protocol Call where Self.Response: Codable {
    associatedtype Response

    var responseType: Response.Type { get }
    var httpScheme: String { get }
    var httpQuery: String { get }
    var httpMethod: HTTPMethod { get }
    var parameters: [String : Any]? { get }
    var body: Codable? { get }
}

extension Call {
    var part1: String { "http://ec2-3-72-108-183.eu-central-1.compute.amazonaws.com:8080/api/v1/" }
    var httpScheme: String { part1 }
    var parameters: [String : Any]? { nil }
    var body: Codable? { nil }
}
