//
//  CarDetailCore.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 17.04.23.
//

import ComposableArchitecture

class CarDetailCore: ReducerProtocol {
    struct State: Equatable {
        var car: Car
        var chosenCurrency: String
        var startDate: String
        var endDate: String
        var rentCarState: Loadable<RentCar>
        var rentCar: RentCar
        var dismissView: Bool
 
        var isError: Bool {
            guard case .error = rentCarState else {
                return false
            }

            return true
        }

        init(car: Car,
             chosenCurrency: String,
             startDate: String,
             endDate: String,
             rentCarState: Loadable<RentCar> = .none,
             dismissView: Bool = false) {
            self.car = car
            self.chosenCurrency = chosenCurrency
            self.startDate = startDate
            self.endDate = endDate
            self.rentCarState = rentCarState
            self.rentCar = RentCar(
                carId: car.id,
                startDay: startDate,
                endDay: endDate,
                totalCost: car.totalCosts,
                currentCurrency: chosenCurrency,
                email: nil
            )
            self.dismissView = dismissView
        }
    }

    enum Action {
        case rentCar
        case rentCarStateChanged(Loadable<RentCar>)
        case dismissView
        case viewDismissed
        case logout
    }

    @Dependency(\.rentCarService) var service
    @Dependency(\.mainScheduler) var mainScheduler
    @Dependency(\.continuousClock) var clock

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .rentCar:
            return .run { [rentCar = state.rentCar] send in
                await send(.rentCarStateChanged(.loading))

                try await self.clock.sleep(for: .seconds(1))

                let rentCarResponse = try await self.service.rentCar(with: rentCar)

                await send(.rentCarStateChanged(.loaded(rentCarResponse)))
            } catch: { error, send in
                if let httpError = error as? HTTPError {
                    if case .unauthorized = httpError {
                        await send(.dismissView)
                        await send(.logout)
                    } else {
                        await send(.rentCarStateChanged(.error(httpError)))
                    }
                } else {
                    await send(.rentCarStateChanged(.error(.unexpectedError)))
                }
            }

        case let .rentCarStateChanged(rentCarState):
            state.rentCarState = rentCarState

            if case .loaded = rentCarState {
                return .run { send in
                    try await self.clock.sleep(for: .seconds(1))

                    await send(.dismissView)
                } catch: { _, send in
                    await send(.dismissView)
                }
            }

            return .none

        case .dismissView:
            state.dismissView = true

            return .send(.viewDismissed)

        case .viewDismissed:
            return .none

        case .logout:
            return .none
        }
    }
}
