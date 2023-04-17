//
//  CarsCore.swift
//  CarRentaliOS
//
//  Created by Ing. Ebu Celik, BSc on 14.04.23.
//

import Foundation
import ComposableArchitecture
import Clocks

class CarsCore: ReducerProtocol {
    struct State: Equatable {
        @BindingState
        var currentCurrency: String
        @BindingState
        var chosenCurrency: String
        @BindingState
        var startDate: Date = Date.now
        @BindingState
        var endDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date.now)!

        var carsState: Loadable<[Car]>
        var currencyCodeState: Loadable<CurrencyCode>

        var needsRefresh = false

        var carDetailState: CarDetailCore.State?

        init(currentCurrency: String = "EUR",
             chosenCurrency: String = "USD",
             carsState: Loadable<[Car]> = .none,
             currencyCodeState: Loadable<CurrencyCode> = .none,
             carDetailState: CarDetailCore.State? = nil) {
            self.currentCurrency = currentCurrency
            self.chosenCurrency = chosenCurrency
            self.carsState = carsState
            self.currencyCodeState = currencyCodeState
            self.carDetailState = carDetailState
        }
    }

    enum Action: BindableAction {
        case onViewAppear
        case loadCars
        case loadCurrencyCode
        case carsStateChanged(Loadable<[Car]>)
        case currencyCodeStateChanged(Loadable<CurrencyCode>)
        case binding(BindingAction<State>)
        case navigateToCarDetails(Car)
        case resetCarDetailState
        case logout

        case carDetail(CarDetailCore.Action)
    }

    @Dependency(\.carService) var service
    @Dependency(\.currencyCodesService) var currencyCodesService
    @Dependency(\.mainScheduler) var mainScheduler
    @Dependency(\.continuousClock) var clock

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
                return .run { [currentCurrency = state.currentCurrency,
                               chosenCurrency = state.chosenCurrency,
                               startDate = state.startDate,
                               endDate = state.endDate] send in
                    await send(.carsStateChanged(.loading))

                    try await self.clock.sleep(for: .seconds(1))

                    let fromDate = startDate.getStringFormattedDate()
                    let toDate = endDate.getStringFormattedDate()

                    let cars = try await self.service.getAvailableCars(
                        currentCurrency: currentCurrency,
                        chosenCurrency: chosenCurrency,
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

                    try await self.clock.sleep(for: .seconds(1))

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

                if case let .loaded(currencyCode) = currencyCodeState {
                    let currencyCodesWithEUR = ["EUR"] + currencyCode.currencyCodes

                    let currencyCodeWithEUR = CurrencyCode(currencyCodes: currencyCodesWithEUR)
                    state.currencyCodeState = .loaded(currencyCodeWithEUR)
                }

                return .none

            case .binding:
                return .none

            case let .navigateToCarDetails(car):
                state.carDetailState = CarDetailCore.State(
                    car: car,
                    chosenCurrency: state.chosenCurrency,
                    startDate: state.startDate.getStringFormattedDate(),
                    endDate: state.endDate.getStringFormattedDate()
                )

                return .none

            case .logout:
                return .none

            case .carDetail(.viewDismissed):
                return .send(.loadCars)

            case .resetCarDetailState:
                state.carDetailState = nil

                return .none

            case .carDetail(.logout):
                return .send(.logout)

            default:
                return .none
            }
        }
        .ifLet(\.carDetailState, action: /Action.carDetail) {
            CarDetailCore()
        }
    }
}

