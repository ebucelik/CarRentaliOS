//
//  LoginCore.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 18.03.23.
//

import Foundation
import ComposableArchitecture

class LoginCore: ReducerProtocol {
    struct State: Equatable {
        @BindingState
        var customer: Customer
    }

    enum Action: BindableAction {
        case showRegister
        case login
        case none
        case binding(BindingAction<State>)
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .showRegister:
                return .none
            case .login:

                UserDefaults.standard.set("access", forKey: "accessToken")
                UserDefaults.standard.synchronize()

                return .none
            case .none:
                return .none

            case .binding:
                return .none
            }
        }
    }
}
