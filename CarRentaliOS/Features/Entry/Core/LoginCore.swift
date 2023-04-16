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
        var customer: LoginCustomer

        var tokenState: Loadable<Token> = .none

        var isError: Bool {
            if case .error = tokenState {
                return true
            }

            return false
        }
    }

    enum Action: BindableAction {
        case showRegister
        case login
        case signedIn
        case tokenStateChanged(Loadable<Token>)
        case none
        case binding(BindingAction<State>)
    }

    @Dependency(\.loginService) var service
    @Dependency(\.mainScheduler) var mainScheduler

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .showRegister:
                return .none

            case .login:
                return .task { [customer = state.customer] in
                    let token = try await self.service.login(loginCustomer: customer)

                    return .tokenStateChanged(.loaded(token))
                } catch: { error in
                    if let httpError = error as? HTTPError {
                        return .tokenStateChanged(.error(httpError))
                    }

                    return .tokenStateChanged(.error(HTTPError.unexpectedError))
                }
                .debounce(id: DebounceID(), for: 1, scheduler: self.mainScheduler)
                .prepend(.tokenStateChanged(.loading))
                .eraseToEffect()

            case .signedIn:
                return .none

            case let .tokenStateChanged(tokenState):
                state.tokenState = tokenState

                if case let .loaded(token) = tokenState {
                    Token.saveTokenInUserDefaults(token)

                    return .send(.signedIn)
                }

                return .none

            case .none:
                return .none

            case .binding:
                return .none
            }
        }
    }
}
