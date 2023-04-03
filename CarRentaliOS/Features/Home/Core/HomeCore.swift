//
//  HomeCore.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 20.03.23.
//

import Foundation
import ComposableArchitecture

class HomeCore: ReducerProtocol {
    struct State: Equatable {
        var accessToken: String = ""
    }

    enum Action {
        case logout
        case none
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .logout:

            UserDefaults.standard.removeObject(forKey: "accessToken")
            UserDefaults.standard.synchronize()

            return .none

        case .none:
            return .none
        }
    }
}
