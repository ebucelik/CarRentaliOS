//
//  RegisterCore.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 18.03.23.
//

import ComposableArchitecture

class RegisterCore: ReducerProtocol {
    struct State: Equatable {

    }

    enum Action {
        case showLogin
        case register
        case none
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .showLogin:
            return .none
        case .register:
            return .none
        case .none:
            return .none
        }
    }
}
