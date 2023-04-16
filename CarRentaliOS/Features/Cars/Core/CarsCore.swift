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
        var currencyCodeState: Loadable<CurrencyCode>

        var needsRefresh = false

        init(selectedCurrency: String = "USD",
             carsState: Loadable<[Car]> = .none,
             currencyCodeState: Loadable<CurrencyCode> = .none) {
            self.selectedCurrency = selectedCurrency
            self.carsState = carsState
            self.currencyCodeState = currencyCodeState
        }
    }

    enum Action: BindableAction {
        case onViewAppear
        case loadCars
        case loadCurrencyCode
        case carsStateChanged(Loadable<[Car]>)
        case currencyCodeStateChanged(Loadable<CurrencyCode>)
        case binding(BindingAction<State>)
        case logout
    }

    @Dependency(\.carService) var service
    @Dependency(\.currencyCodesService) var currencyCodesService
    @Dependency(\.mainScheduler) var mainScheduler

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onViewAppear:
                state.needsRefresh = false

                return .concatenate([
                    .send(.loadCurrencyCode),
                    .send(.loadCars)
                ])

            case .loadCars:
                return .run { [selectedCurrency = state.selectedCurrency,
                               startDate = state.startDate,
                               endDate = state.endDate] send in
                    await send(.carsStateChanged(.loading))

                    try await Task.sleep(for: .seconds(1))

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let fromDate = dateFormatter.string(from: startDate)
                    let toDate = dateFormatter.string(from: endDate)

                    let cars = try await self.service.getAvailableCars(
                        currency: selectedCurrency,
                        startDate: fromDate,
                        endDate: toDate
                    )

                    await send(.carsStateChanged(.loaded(cars)))
                } catch: { error, send  in
                    if let httpError = error as? HTTPError {
                        if case .unauthorized = httpError {
                            await send(.logout)
                        } else {
                            await send(.carsStateChanged(.error(httpError)))
                        }
                    } else {
                        await send(.carsStateChanged(.error(.unexpectedError)))
                    }
                }

            case .loadCurrencyCode:
                return .run { send in
                    await send(.currencyCodeStateChanged(.loading))

                    try await Task.sleep(for: .seconds(1))

                    let currencyCode = try await self.currencyCodesService.getCurrencyCodes()

                    await send(.currencyCodeStateChanged(.loaded(currencyCode)))
                } catch: { error, send  in
                    if let httpError = error as? HTTPError {
                        if case .unauthorized = httpError {
                            await send(.logout)
                        } else {
                            await send(.currencyCodeStateChanged(.error(httpError)))
                        }
                    } else {
                        await send(.currencyCodeStateChanged(.error(.unexpectedError)))
                    }
                }

            case let .carsStateChanged(carsState):
                state.carsState = carsState

                return .none

            case let .currencyCodeStateChanged(currencyCodeState):
                state.currencyCodeState = currencyCodeState

                return .none

            case .binding:
                return .none

            case .logout:
                return .none
            }
        }
    }
}

