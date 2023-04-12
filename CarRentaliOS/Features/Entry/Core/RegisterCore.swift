//
//  RegisterCore.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 18.03.23.
//

import ComposableArchitecture

class RegisterCore: ReducerProtocol {
    struct State: Equatable {
        @BindingState
        var customer: Customer
    }

    enum Action: BindableAction {
        case showLogin
        case register
        case signedUp
        case none
        case binding(BindingAction<State>)
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .showLogin:
                return .none

            case .register:
                return .none

            case .signedUp:
                return .none

            case .none:
                return .none

            case .binding:
                return .none
            }
        }
    }
}
