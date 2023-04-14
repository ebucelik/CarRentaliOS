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
        var accessToken: String = ""

        @BindingState
        var showToolbar: Bool = false

        var carsState: CarsCore.State = CarsCore.State()
    }

    enum Action: BindableAction {
        case logout
        case showToolbar
        case none
        case binding(BindingAction<State>)

        case carAction(CarsCore.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Scope(
            state: \.carsState,
            action: /HomeCore.Action.carAction
        ) {
            CarsCore()
        }

        Reduce { state, action in
            switch action {
            case .logout:

                UserDefaults.standard.removeObject(forKey: "accessToken")
                UserDefaults.standard.synchronize()

                return .none

            case .showToolbar:
                state.showToolbar.toggle()

                return .none

            case .none:
                return .none

            case .binding:
                return .none

            case .carAction:
                return .none
            }
        }
    }
}
