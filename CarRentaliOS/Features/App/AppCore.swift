//
//  AppCore.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 18.03.23.
//

import Foundation
import ComposableArchitecture

class AppCore: ReducerProtocol {
    struct State: Equatable {
        @BindingState
        var showEntry: Bool = false

        var homeState: HomeCore.State
        var entryState: EntryCore.State
    }

    enum Action: BindableAction {
        case checkAccessToken

        case home(HomeCore.Action)
        case entry(EntryCore.Action)

        case binding(BindingAction<State>)
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .checkAccessToken:
                if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
                    state.homeState.accessToken = accessToken

                    return .task { .home(.none) }
                }

                return .task { .entry(.none) }

            case .home(.none):
                state.showEntry = false

                return .none

            case .entry(.none), .home(.logout):
                state.showEntry = true

                return .none

            case .entry(.home):
                return .task { .home(.none) }

            case .binding:
                return .none

            default:
                return .none
            }
        }

        Scope(
            state: \.entryState,
            action: /Action.entry
        ) {
            EntryCore()
        }

        Scope(
            state: \.homeState,
            action: /Action.home
        ) {
            HomeCore()
        }
    }
}
