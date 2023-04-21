//
//  RentalCore.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 21.04.23.
//

import ComposableArchitecture

class RentalCore: ReducerProtocol {
    struct State: Equatable {
        var currentCurrency: String
        var rentalState: Loadable<[Rental]>

        init(currentCurrency: String = "USD",
             rentalState: Loadable<[Rental]> = .none) {
            self.currentCurrency = currentCurrency
            self.rentalState = rentalState
        }
    }

    enum Action {
        case onViewAppear
        case rentalStateChanged(Loadable<[Rental]>)
        case logout
    }

    @Dependency(\.rentalService) var service
    @Dependency(\.mainScheduler) var mainScheduler
    @Dependency(\.continuousClock) var clock

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .run { [currentCurrency = state.currentCurrency] send in
                    await send(.rentalStateChanged(.loading))

                    try await self.clock.sleep(for: .seconds(1))

                    let rentals = try await self.service.getAllRentals(for: currentCurrency)

                    await send(.rentalStateChanged(.loaded(rentals)))
                } catch: { error, send in
                    if let httpError = error as? HTTPError {
                        if case .unauthorized = httpError {
                            await send(.logout)
                        } else {
                            await send(.rentalStateChanged(.error(httpError)))
                        }
                    } else {
                        await send(.rentalStateChanged(.error(.unexpectedError)))
                    }
                }

            case let .rentalStateChanged(rentalState):
                state.rentalState = rentalState

                return .none

            case .logout:
                return .none
            }
        }
    }
}
