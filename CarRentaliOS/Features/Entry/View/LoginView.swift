//
//  LoginView.swift
//  CarRental
//
//  Created by Ing. Ebu Celik, BSc on 18.03.23.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {

    let store: StoreOf<LoginCore>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 15) {
                SharedTextView(
                    systemSymbol: .personFill,
                    placeholder: "Username",
                    text: viewStore.binding(\.$customer.username)
                )

                SharedTextView(
                    secure: true,
                    systemSymbol: .lockFill,
                    placeholder: "Password",
                    text: viewStore.binding(\.$customer.password)
                )

                Text("Click on me to go to home")
                    .onTapGesture {
                        viewStore.send(.login)
                    }
            }
            .padding()
        }
    }
}
