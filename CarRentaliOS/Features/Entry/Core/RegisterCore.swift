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

        var registrationCustomerState: Loadable<RegistrationCustomer>

        var isError: Bool {
            if case .error = registrationCustomerState {
                return true
            }

            return false
        }

        init(customer: Customer,
             registrationCustomerState: Loadable<RegistrationCustomer> = .none) {
            self.customer = customer
            self.registrationCustomerState = registrationCustomerState
        }
    }

    enum Action: BindableAction {
        case showLogin
        case register
        case registrationCustomerStateChanged(Loadable<RegistrationCustomer>)
        case signedUp
        case none
        case binding(BindingAction<State>)
    }

    @Dependency(\.registerService) var service
    @Dependency(\.mainScheduler) var mainScheduler

    struct DebounceID: Hashable {}

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .showLogin:
                return .none

            case .register:
                return .task { [customer = state.customer] in
                    let registrationCustomer = try await self.service.register(customer: customer)

                    return .registrationCustomerStateChanged(.loaded(registrationCustomer))
                } catch: { error in
                    if let httpError = error as? HTTPError {
                        return .registrationCustomerStateChanged(.error(httpError))
                    }

                    return .registrationCustomerStateChanged(.error(HTTPError.unexpectedError))
                }
                .debounce(id: DebounceID(), for: 1, scheduler: self.mainScheduler)
                .prepend(.registrationCustomerStateChanged(.loading))
                .eraseToEffect()


            case let .registrationCustomerStateChanged(registrationCustomerState):
                state.registrationCustomerState = registrationCustomerState

                if case .loaded = registrationCustomerState {
                    return .send(.showLogin)
                }

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
