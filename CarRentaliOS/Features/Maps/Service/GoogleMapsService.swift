//
//  GoogleMapsService.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 03.04.23.
//

import Foundation

class GoogleMapsService: APIClient, GoogleMapsServiceProtocol {

    // Add this as parameter key=API_KEY
    static let apiKey = "AIzaSyBkCgBv_PAxSnMK5pTEPFS85A3lH9uaMtw"

    override init() {
        super.init()
    }
}
