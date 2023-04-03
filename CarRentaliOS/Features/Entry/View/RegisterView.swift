//
//  RegisterView.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 18.03.23.
//

import SwiftUI
import ComposableArchitecture

struct RegisterView: View {

    let store: StoreOf<RegisterCore>

    var body: some View {
        WithViewStore(store) { viewStore in
            Text("Click on me to go to login view")
                .onTapGesture {
                    viewStore.send(.showLogin)
                }

            Text("Click on me to go to home")
                .onTapGesture {
                    viewStore.send(.register)
                }
        }
    }
}
