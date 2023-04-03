//
//  EntryCore.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 20.03.23.
//

import ComposableArchitecture

class EntryCore: ReducerProtocol {
    struct State: Equatable {
        var loginState: LoginCore.State?
        var registerState: RegisterCore.State?
    }

    enum Action {
        case login(LoginCore.Action)
        case register(RegisterCore.Action)
        case home
        case none
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .login(.login), .register(.register):
                return .task { .home }

            case .login(.showRegister):
                state.loginState = nil
                state.registerState = RegisterCore.State()

                return .none

            case .register(.showLogin):
                state.registerState = nil
                state.loginState = LoginCore.State(
                    customer: .emptyCustomer
                )

                return .none

            default:
                return .none
            }
        }
        .ifLet(\.loginState, action: /Action.login) {
            LoginCore()
        }
        .ifLet(\.registerState, action: /Action.register) {
            RegisterCore()
        }
    }
}
