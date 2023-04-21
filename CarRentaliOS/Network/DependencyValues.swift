//
//  DependencyValues.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 13.04.23.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var registerService: RegisterService {
        get { self[RegisterService.self] }
        set { self[RegisterService.self] = newValue }
    }

    var loginService: LoginService {
        get { self[LoginService.self] }
        set { self[LoginService.self] = newValue }
    }

    var mainScheduler: DispatchQueue {
        get { self[DispatchQueue.self] }
        set { self[DispatchQueue.self] = newValue }
    }

    var carService: CarService {
        get { self[CarService.self] }
        set{ self[CarService.self] = newValue }
    }

    var currencyCodesService: CurrencyCodeService {
        get { self[CurrencyCodeService.self] }
        set { self[CurrencyCodeService.self] = newValue }
    }

    var rentCarService: RentCarService {
        get { self[RentCarService.self] }
        set { self[RentCarService.self] = newValue }
    }

    var rentalService: RentalService {
        get { self[RentalService.self] }
        set { self[RentalService.self] = newValue }
    }
}

extension DispatchQueue: DependencyKey {
    public static let liveValue: DispatchQueue = .main
}
