//
//  HomeCore.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 20.03.23.
//

import Foundation
import ComposableArchitecture

class HomeCore: ReducerProtocol {
    struct State: Equatable {
        var currentCurrency: String = "USD"

        var carsState: CarsCore.State = CarsCore.State()
        var rentalState: RentalCore.State = RentalCore.State()
    }

    enum Action {
        case logout
        case none

        case carAction(CarsCore.Action)
        case rentalAction(RentalCore.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Scope(
            state: \.carsState,
            action: /HomeCore.Action.carAction
        ) {
            CarsCore()
        }
        
        Scope(
            state: \.rentalState,
            action: /HomeCore.Action.rentalAction
        ) {
            RentalCore()
        }

        Reduce { state, action in
            switch action {
            case .logout:

                Token.removeTokenFromUserDefaults()

                return .none

            case .none:
                return .none

            case .carAction(.logout), .rentalAction(.logout):
                return .send(.logout)

            case .carAction(.currencyCodeChosen):
                state.currentCurrency = state.carsState.chosenCurrency
                state.rentalState.currentCurrency = state.currentCurrency

                return .none

            default:
                return .none
            }
        }
    }
}
