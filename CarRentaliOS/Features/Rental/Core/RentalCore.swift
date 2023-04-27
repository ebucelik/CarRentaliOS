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
        var deleteRentalState: Loadable<Empty>

        init(currentCurrency: String = "USD",
             rentalState: Loadable<[Rental]> = .none,
             deleteRentalState: Loadable<Empty> = .none) {
            self.currentCurrency = currentCurrency
            self.rentalState = rentalState
            self.deleteRentalState = deleteRentalState
        }
    }

    enum Action {
        case onViewAppear
        case rentalStateChanged(Loadable<[Rental]>)
        case deleteRental(Int)
        case deleteRentalStateChanged(Loadable<Empty>)
        case logout
    }

    @Dependency(\.rentalService) var service
    @Dependency(\.mainScheduler) var mainScheduler

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:

                return .run { [currentCurrency = state.currentCurrency] send in
                    await send(.rentalStateChanged(.loading))

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

            case let .deleteRental(id):
                guard case let .loaded(rentals) = state.rentalState else { return .none }

                let rental = rentals[id]

                return .run { send in
                    await send(.deleteRentalStateChanged(.loading))

                    let empty = try await self.service.deleteRental(with: rental.id)

                    await send(.deleteRentalStateChanged(.loaded(empty)))
                } catch: { error, send in
                    if let httpError = error as? HTTPError {
                        if case .unauthorized = httpError {
                            await send(.logout)
                        } else {
                            await send(.deleteRentalStateChanged(.error(httpError)))
                        }
                    } else {
                        await send(.deleteRentalStateChanged(.error(.unexpectedError)))
                    }
                }

            case let .deleteRentalStateChanged(deleteRentalState):
                state.deleteRentalState = deleteRentalState

                if case .loaded = deleteRentalState {
                    return .send(.onViewAppear)
                }

                return .none

            case .logout:
                return .none
            }
        }
    }
}
