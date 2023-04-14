//
//  CarsCore.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 14.04.23.
//

import Foundation
import ComposableArchitecture

class CarsCore: ReducerProtocol {
    struct State: Equatable {
        @BindingState
        var selectedCurrency: String
        @BindingState
        var startDate: Date = Date.now
        @BindingState
        var endDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date.now)!

        var carsState: Loadable<[Car]>

        var mockedCurrencies = ["EUR", "USD", "TRY", "BRL", "CHF"]

        init(selectedCurrency: String = "EUR",
             carsState: Loadable<[Car]> = .none) {
            self.selectedCurrency = selectedCurrency
            self.carsState = carsState
        }
    }

    enum Action: BindableAction {
        case onViewAppear
        case carsStateChanged(Loadable<[Car]>)
        case binding(BindingAction<State>)
    }

    @Dependency(\.carService) var service
    @Dependency(\.mainScheduler) var mainScheduler

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .run { [selectedCurrency = state.selectedCurrency] send in
                    await send(.carsStateChanged(.loading))

                    try await Task.sleep(for: .seconds(1))

                    let cars = try await self.service.getAllCars(currency: selectedCurrency)

                    await send(.carsStateChanged(.loaded(cars)))
                } catch: { error, send  in
                    if let httpError = error as? HTTPError {
                        await send(.carsStateChanged(.error(httpError)))
                    } else {
                        await send(.carsStateChanged(.error(.unexpectedError)))
                    }
                }

            case let .carsStateChanged(carsState):
                state.carsState = carsState

                return .none

            case .binding:
                return .none
            }
        }
    }
}

