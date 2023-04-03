//
//  AppView.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 18.03.23.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {

    let store: StoreOf<AppCore>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                HomeView(
                    store: store.scope(
                        state: \.homeState,
                        action: AppCore.Action.home
                    )
                )
                .fullScreenCover(isPresented: viewStore.binding(\.$showEntry), content: {
                    EntryView(
                        store: store.scope(
                            state: \.entryState,
                            action: AppCore.Action.entry
                        )
                    )
                })
                .onAppear {
                    viewStore.send(.checkAccessToken)
                }
            }
        }
    }
}
