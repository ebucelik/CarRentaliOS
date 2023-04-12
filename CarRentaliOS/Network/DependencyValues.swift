//
//  DependencyValues.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 13.04.23.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var loginService: LoginService {
        get { self[LoginService.self] }
        set { self[LoginService.self] = newValue }
    }

    var mainScheduler: DispatchQueue {
        get { self[DispatchQueue.self] }
        set { self[DispatchQueue.self] = newValue }
    }
}

extension DispatchQueue: DependencyKey {
    public static let liveValue: DispatchQueue = .main
}
