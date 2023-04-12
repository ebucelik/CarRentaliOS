//
//  EntryView.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 20.03.23.
//

import SwiftUI
import ComposableArchitecture

struct EntryView: View {

    let store: StoreOf<EntryCore>

    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                IfLetStore(
                    store.scope(
                        state: \.loginState,
                        action: EntryCore.Action.login
                    )
                ) { loginStore in
                    LoginView(store: loginStore)
                }

                IfLetStore(
                    store.scope(
                        state: \.registerState,
                        action: EntryCore.Action.register
                    )
                ) { registerStore in
                    RegisterView(store: registerStore)
                }
            }
        }
    }
}
